##################
# 
#   Bitmap Fonts, (C) 2008 Peter O.
#


##################
# 
#   Modified marshal class for reading raw data,
#   even within encrypted archives
#

module ::Marshal
class << self
  if !@oldloadAliased
    alias oldload load
    @oldloadAliased=true
  end
  def neverload
    return @@neverload
  end
  @@neverload=false
  def neverload=(value)
    @@neverload=value
  end
  def load(port,*arg)
     if @@neverload
       if port.is_a?(IO)
          return port.read
       else
          return port
       end
     end
     oldpos=port.pos if port.is_a?(IO)
     begin
        oldload(port,*arg)
     rescue
        if port.is_a?(IO)
          port.pos=oldpos
          return port.read
        else
          return port
        end
     end
  end
end
end

def loadRawData(file)
  oldload=Marshal.neverload
  begin
     ret=load_data(file)
     return ret
  rescue
     return ""
  ensure
     Marshal.neverload=oldload
  end
end


##################
# 
#   CSV Routines
#


def csvfield!(str)
  ret=""
  str.sub!(/^\s*/,"")
  return nil if str.length==0
  if str[0,1]=="\""
    str[0,1]=""
    escaped=false
    fieldbytes=0
    str.scan(/./) do |s|
     fieldbytes+=s.length
     break if s=="\"" && !escaped
     if s=="\\" && !escaped
       escaped=true
     else
       ret+=s
       escaped=false
     end
    end
    str[0,fieldbytes]=""
    # Remove everything before the comma
    str.sub!(/^[^,]*,?/,"")
  else
    if str[/,/]
     str[0,str.length]=$~.post_match
     ret=$~.pre_match
    else
     ret=str.clone
     str[0,str.length]=""
    end
    ret.gsub!(/\s+$/,"")
  end
  return ret
end

def csvGetPosInt(ret)
if !ret || !ret[/^\d+$/]
  return nil
end
return ret.to_i
end

def csvGetInt(ret)
if !ret || !ret[/^\-?\d+$/]
  return nil
end
return ret.to_i
end

def csvGetFields(str)
str=str.dup
ret=[]
loop do
  field=csvfield!(str)
  if field==nil
    return ret
  end
  ret.push(field)
end
end


def pbFileEachPreppedLine(filename)
data=loadRawData(filename)
lineno=1
data.each_line {|line|
    if lineno==1 && line[0]==0xEF && line[1]==0xBB && line[2]==0xBF
     line=line[3,line.length-3]
    end
    if !line[/^\#/] && !line[/^\s*$/]
     yield line, lineno
    end
    lineno+=1
}
end

def getBitmapFontRecords(filename)
records={}
# rr=[]
pbFileEachPreppedLine(filename) {|line, lineno|
  record=csvGetFields(line)
  # converting values to integers
  record[1]=csvGetPosInt(record[1]) # glyph start X
  record[2]=csvGetInt(record[2]) # start X
  record[3]=csvGetPosInt(record[3]) # width
  record[4]=csvGetInt(record[4]) # end X (if unequal to glyph start X + width) 
  # checking required string
  if !record[0] || record[0].length==0
    next
  end
  # checking required values
  if !record[1] || !record[2] || !record[3]
    next
  end
  # checking optional value
  if !record[4]
    record[4]=record[1]+record[3] 
  end
  records[record[0]]=[
    # Offset from end of last glyph to start of this glyph
    record[1]-record[2],
    # Offset from end of this glyph to start of next glyph
    record[4]-(record[1]+record[3]),
    record[1], # source start X
    record[3]   # source width
  ]
}
return records
end


def csvquote(str)
return "" if !str || str==""
if str[/[,\"]/] || str[/^\s/] || str[/\s$/] || str[/^#/]
  str=str.sub(/[\"]/,"\\\"")
  str="\"#{str}\""
end
return str
end

##################
# 
#   High-speed bitmap access
#

class Bitmap
  # Fast methods for retrieving bitmap data
  RtlMoveMemory_pi = Win32API.new('kernel32', 'RtlMoveMemory', 'pii', 'i')
  RtlMoveMemory_ip = Win32API.new('kernel32', 'RtlMoveMemory', 'ipi', 'i')
  def setData(x)
     RtlMoveMemory_ip.call(self.address, x, x.length)      
  end
  def getData
     data = "rgba" * width * height
     RtlMoveMemory_pi.call(data, self.address, data.length)
     return data
  end
  def swap32(x)
    return ((x>>24)&0x000000FF)|
              ((x>>8)&0x0000FF00)|
              ((x<<8)&0x00FF0000)|            
              ((x<<24)&0xFF000000)
  end
  def saveToPng(filename)
    bytes=[
     0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A,
     0x00,0x00,0x00,0x0D
    ].pack("CCCCCCCCCCCC")
    ihdr=[
     0x49,0x48,0x44,0x52,
     swap32(self.width),
     swap32(self.height),
     0x08,0x06,0x00,0x00,0x00
    ].pack("CCCCVVCCCCC")
    crc=Zlib::crc32(ihdr)
    ihdr+=[swap32(crc)].pack("V")
    bytesPerScan=self.width*4
    row=(self.height-1)*bytesPerScan
    data=self.getData
    width=self.width
    x=""
    while row>=0
     x+="\0"
     thisRow=data[row,bytesPerScan]
     i=0;while i<width
       b=i<<2
       bp2=b+2
       t=thisRow[b]
       thisRow[b]=thisRow[bp2]
       thisRow[bp2]=t
       i+=1
     end
     x+=thisRow
     row-=bytesPerScan
    end
    x=Zlib::Deflate.deflate(x)
    length=x.length
    x="IDAT"+x
    crc=Zlib::crc32(x)
    idat=[swap32(length)].pack("V")
    idat+=x
    idat+=[swap32(crc)].pack("V")
    idat+=[0,0x49,0x45,0x4E,0x44,0xAE,0x42,0x60,0x82].pack("VCCCCCCCC")
    File.open(filename,"wb"){|f|
     f.write(bytes)
     f.write(ihdr)
     f.write(idat)
    }
  end
  def address
     if !@address
        buffer, ad = "rgba", object_id * 2 + 16
        RtlMoveMemory_pi.call(buffer, ad, 4)
        ad = buffer.unpack("L")[0] + 8
        RtlMoveMemory_pi.call(buffer, ad, 4)
        ad = buffer.unpack("L")[0] + 16
        RtlMoveMemory_pi.call(buffer, ad, 4)
        @address=buffer.unpack("L")[0]
     end
     return @address
  end
end

##################
# 
#   Draws and saves a bitmap font
#

def drawBitmapFont(bitmap,filename)
x=0
height=bitmap.text_size("X").height
for i in 0x20..0xFF
  next if i>=0x7F && i<0xA0
  s=[i].pack("U")
  x+=bitmap.text_size(s).width+2
end
width=x
x=0
rbitmap=Bitmap.new([width,1].max,[height,1].max)
rbitmap.font.name=bitmap.font.name
rbitmap.font.color=bitmap.font.color
rbitmap.font.size=bitmap.font.size
File.open("#{filename}.txt","wb"){|f|
  for i in 0x20..0xFF
    next if i>=0x7F && i<0xA0
    s=[i].pack("U")
    w=rbitmap.text_size(s).width
    f.write(csvquote(s)+",#{x},#{x},#{w+2},#{x+w}\r\n")
    rbitmap.draw_text(x,0,w+2,height,s,0)
    x+=w+2
  end
}
rbitmap.saveToPng("#{filename}.png")
end

##################
# 
#   Bitmap Font Class
#

class BitmapFont
def initialize(bmfont)
  @bitmap=Bitmap.new("Graphics/Pictures/"+bmfont+".png")
  @records=getBitmapFontRecords("Graphics/Pictures/"+bmfont+".txt")
end
def textSize(string)
  x=0
  textEndX=0
  records=@records
  string.scan(/./m){|c|
    rec=records[c]
    next if !rec
    x+=rec[0] # move x by offset from end of last glyph
    x+=rec[3] # add glyph width
    textEndX=x # set total width to x
    x+=rec[1] # add offset from end of this glyph
  }
  return Rect.new(0,0,textEndX,@bitmap.height)
end
def drawText(bitmap,x,y,width,height,string,alignment=0,opacity=255)
  return if !string || string.length==0
  positions=[]
  records=@records
  realEndX=x+width
  realEndY=y+height
  return if y>=bitmap.height || height<=0
  return if x>=bitmap.width || width<=0
  dstY=y+(height/2)-(@bitmap.height/2)
  srcHeight=height<@bitmap.height ? height : @bitmap.height
  textStartX=x
  first=true
  textEndX=x
  string.scan(/./m){|c|
    rec=records[c]
    next if !rec
    x+=rec[0] # move x by offset from end of last glyph
    textStartX=x if first
    first=false
    break if x>=realEndX || y>=realEndY
    endx=x+rec[3] # x plus glyph width
    endx=width if endx>realEndX
    next if x>=endx
    positions.push([
       # destination
       x,dstY,
       # source
       Rect.new(rec[2],0,endx-x,srcHeight)
    ])
    x+=rec[3] # add glyph width
    textEndX=x
    x+=rec[1] # add offset from end of this glyph
  }
  totalWidth=textEndX-textStartX
  offset=0
  if alignment==1
     offset=(width/2)-(totalWidth/2)
  elsif alignment==2
     offset=width-totalWidthÂ     
  end
  for pos in positions
    bitmap.blt(
     pos[0]+offset,pos[1],@bitmap,pos[2]
    )
  end
end
end

module BitmapFontCache
  @cache={}
  def self.load(name)
     if @cache.include?(name)
        return @cache[name]
     end
     bmfont=nil
     begin
        bmfont=BitmapFont.new(name)
     rescue
        bmfont=nil
     end
     @cache[name]=bmfont
     return bmfont
  end
end

class Font
  def checkBitmapFont(name)
     return nil if !name
     if name.is_a?(Array)
        for i in name
          bmfont=BitmapFontCache.load(i)
          return bmfont if bmfont
        end
        return nil
     else
       return BitmapFontCache.load(name)
     end
  end
  def bitmapFont
     return checkBitmapFont(self.name)
  end
end

class Bitmap
  if !defined?(petero_bitmapfont_text_size)
     alias petero_bitmapfont_text_size text_size
     alias petero_bitmapfont_draw_text draw_text
  end
def text_size(str)
  bmfont=self.font.bitmapFont
  if bmfont
    return bmfont.textSize(str)
  else
    return petero_bitmapfont_text_size(str)
  end
end
def draw_text(*args)
  bmfont=self.font.bitmapFont
  if bmfont
    if args.length==2 || args.length==3
     rc=args[0]
     bmfont.drawText(self,rc.x,rc.y,rc.width,rc.height,
        args[1],args[2] ? args[2] : 0)
    elsif args.length==5 || args.length==6
     bmfont.drawText(self,args[0],args[1],args[2],args[3],
       args[4],args[5] ? args[5] : 0)     
    end
  else
    return petero_bitmapfont_draw_text(*args)     
  end
end
end
