#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  Esta clase almacena las variables sobre datos y comandos del sistema, como
#  la reproducción de música y sonido, el windowskin, temporizador, etc
#  Llama a $game_system para acceder a las variables incluidas aquí.
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Variables Globales
  #--------------------------------------------------------------------------
  attr_reader   :map_interpreter          # Intérprete de eventos en mapa
  attr_reader   :battle_interpreter       # Intérprete de eventos en batalla
  attr_accessor :timer                    # Temporizador
  attr_accessor :timer_working            # Temporizador funcionando
  attr_accessor :save_disabled            # Llamada a Guardar deshabilitado
  attr_accessor :menu_disabled            # Llamada a Menú deshabilitado
  attr_accessor :encounter_disabled       # Encuentro de enemigos deshabilitado
  attr_accessor :message_position         # Opción de Mensaje:Posición de la Ventana
  attr_accessor :message_frame            # Opción de Mensaje: Marco
  attr_accessor :save_count               # Contador de Partidas Guardadas
  attr_accessor :magic_number             # Número de Magia
  #--------------------------------------------------------------------------
  # * Inicio de Objetos (Aquí se agrega el valor inicial a cada variable)
  #--------------------------------------------------------------------------
  def initialize
    @map_interpreter = Interpreter.new(0, true)
    @battle_interpreter = Interpreter.new(0, false)
    @timer = 0
    @timer_working = false
    @save_disabled = false
    @menu_disabled = false
    @encounter_disabled = false
    @message_position = 2
    @message_frame = 0
    @save_count = 0
    @magic_number = 0
  end
  #--------------------------------------------------------------------------
  # * Reproducción de Sonidos
  #   A partir de aquí están las métodos que incluyen los datos sobre la
  #   reproducción de todo tipo de sonido(música, ambiente, efecto sonoro, etc)
  #   Para que los comandos de reproducción funcionen corréctamente la variable
  #   que contiene el archivo de sonido debe ser la clase RPG::AudioFile
  #   y contener en su método de inicio (nombre, volúmen, tono)
  #   Puedes llamar a esta clase con el siguiente método:
  #   RPG::AudioFile.new(nombre, volúmen, tono)
  #   Los valores por defecto son ("", 100, 100)
  #--------------------------------------------------------------------------
  # * Reproducir Música
  #     "bgm" es la variable que incluye el archivo que se reproduce
  #--------------------------------------------------------------------------
  def bgm_play(bgm)
    @playing_bgm = bgm
    if bgm != nil and bgm.name != ""
      Audio.bgm_play("Audio/BGM/" + bgm.name, bgm.volume, bgm.pitch)
    else
      Audio.bgm_stop
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # * Detener Música
  #--------------------------------------------------------------------------
  def bgm_stop
    Audio.bgm_stop
  end
  #--------------------------------------------------------------------------
  # * Decrecer Música
  #     "time" es la variable que determina el tiempo en segundos del decrecimiento
  #--------------------------------------------------------------------------
  def bgm_fade(time)
    @playing_bgm = nil
    Audio.bgm_fade(time * 1000)
  end
  #--------------------------------------------------------------------------
  # * Memorizar Música
  #   Al usar este comando se guarda la BGM que se está reproduciendo en la
  #   variable local memorized_bgm dentro de esta misma clase
  #--------------------------------------------------------------------------
  def bgm_memorize
    @memorized_bgm = @playing_bgm
  end
  #--------------------------------------------------------------------------
  # * Reproducir Música Memorizada
  #   Al usar este comando, se reproduce la BGM incluida en la
  #   variable local memorized_bgm
  #--------------------------------------------------------------------------
  def bgm_restore
    bgm_play(@memorized_bgm)
  end
  #--------------------------------------------------------------------------
  # * Reproducir Sonido de Fondo
  #     "bgs" es la variable que incluye el archivo que se reproduce
  #--------------------------------------------------------------------------
  def bgs_play(bgs)
    @playing_bgs = bgs
    if bgs != nil and bgs.name != ""
      Audio.bgs_play("Audio/BGS/" + bgs.name, bgs.volume, bgs.pitch)
    else
      Audio.bgs_stop
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # * Decrecer Sonido de Fondo
  #     "time" es la variable que determina el tiempo en segundos del decrecimiento
  #--------------------------------------------------------------------------
  def bgs_fade(time)
    @playing_bgs = nil
    Audio.bgs_fade(time * 1000)
  end
  #--------------------------------------------------------------------------
  # * Memorizar Sonido de Fondo
  #   Al usar este comando se guarda el BGS que se está reproduciendo en la
  #   variable local memorized_bgs dentro de esta misma clase
  #--------------------------------------------------------------------------
  def bgs_memorize
    @memorized_bgs = @playing_bgs
  end
  #--------------------------------------------------------------------------
  # * Reproducir Sonido de Fondo Memorizado
  #   Al usar este comando, se reproduce el BGS incluido en la
  #   variable local memorized_bgs
  #--------------------------------------------------------------------------
  def bgs_restore
    bgs_play(@memorized_bgs)
  end
  #--------------------------------------------------------------------------
  # * Reproducir Efecto Musical
  #     "me" es ña variable que incluye el archivo que se reproducirá
  #--------------------------------------------------------------------------
  def me_play(me)
    if me != nil and me.name != ""
      Audio.me_play("Audio/ME/" + me.name, me.volume, me.pitch)
    else
      Audio.me_stop
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # * Reproducir Efecto Sonoro
  #     "se" es el archivo que se reproducirá
  #--------------------------------------------------------------------------
  def se_play(se)
    if se != nil and se.name != ""
      Audio.se_play("Audio/SE/" + se.name, se.volume, se.pitch)
    end
  end
  #--------------------------------------------------------------------------
  # * Parar Efectos Sonoros
  #--------------------------------------------------------------------------
  def se_stop
    Audio.se_stop
  end
  # Sonidos en reproducción
  # Los dos métodos siguientes sirven para extraer los sonidos que están
  # actualmente en reproducción. Usa estos métodos solo para cuando determinar
  # el archivo de sonido en reproducción, por ejemplo, para guardarlos
  # en una variable (variable = $game_system.playing_bgm).
  #--------------------------------------------------------------------------
  # * Música en Reproducción
  # Al usar este método, la música en reproducción es devuelta por el mismo
  #--------------------------------------------------------------------------
  def playing_bgm
    return @playing_bgm
  end
  #--------------------------------------------------------------------------
  # * Sonido de Fondo en Reproducción
  # Al usar este método, el sonido en reproducción es devuelta por el mismo
  #--------------------------------------------------------------------------
  def playing_bgs
    return @playing_bgs
  end
  #--------------------------------------------------------------------------
  # * Archivo de windowskin actual
  #   Usa este método solo para determinar el windowskin que se esta usando
  #--------------------------------------------------------------------------
  def windowskin_name
    if @windowskin_name == nil
      return $data_system.windowskin_name
    else
      return @windowskin_name
    end
  end
  #--------------------------------------------------------------------------
  # * Cambiar windowskin
  #     La variable "windowskin_name" dentro del método, es el nuevo
  #     windowskin al cual quieres cambiar
  #--------------------------------------------------------------------------
  def windowskin_name=(windowskin_name)
    @windowskin_name = windowskin_name
  end
  #--------------------------------------------------------------------------
  # * Música de Batallas
  # Al usar este método, la música de batallas es devuelta por el mismo
  #--------------------------------------------------------------------------
  def battle_bgm
    if @battle_bgm == nil
      return $data_system.battle_bgm
    else
      return @battle_bgm
    end
  end
  #--------------------------------------------------------------------------
  # * Cambiar Música de Batallas
  #     La variable "battle_bgm" dentro del método, es la Música de Batalla
  #     a la cual quieres cambiar
  #--------------------------------------------------------------------------
  def battle_bgm=(battle_bgm)
    @battle_bgm = battle_bgm
  end
  #--------------------------------------------------------------------------
  # * Música de Batallas
  # Al usar este método, la música de fin de batalla es devuelta por el mismo
  #--------------------------------------------------------------------------
  def battle_end_me
    if @battle_end_me == nil
      return $data_system.battle_end_me
    else
      return @battle_end_me
    end
  end
  #--------------------------------------------------------------------------
  # * Cambiar Música de Fin de Batallas
  #     La variable "battle_end_me" dentro del método, es la Música de
  #     Fin de Batalla a la cual quieres cambiar
  #--------------------------------------------------------------------------
  def battle_end_me=(battle_end_me)
    @battle_end_me = battle_end_me
  end
  #--------------------------------------------------------------------------
  # * Actualizar Temporizador
  #--------------------------------------------------------------------------
  def update
    # Se reduce el tiempo restante menos 1
    if @timer_working and @timer > 0
      @timer -= 1
    end
  end
end
