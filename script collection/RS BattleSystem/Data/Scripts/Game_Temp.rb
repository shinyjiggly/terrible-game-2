#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  Esta clase almacena los datos temporales no incluidos en las partidas guardadas.
#  Llama a "$game_temp" para acceder a las variables globales incluidas aquí.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Variables Globales
  #--------------------------------------------------------------------------
  attr_accessor :map_bgm                  # Música de Mapa(Se devuelve al terminar batalla)
  attr_accessor :message_text             # Texto del Mensaje
  attr_accessor :message_proc             # Llamada de Mensaje (Proc)
  attr_accessor :choice_start             # Elecciones: Línea de Comienzo
  attr_accessor :choice_max               # Elecciones: Número de Opciones
  attr_accessor :choice_cancel_type       # Elecciones: Añadir Rama al Cancelar
  attr_accessor :choice_proc              # Elecciones: Llamada (Proc)
  attr_accessor :num_input_start          # Dígitos: Línea de Comienzo
  attr_accessor :num_input_variable_id    # Dígitos: Variable en que se guarda
  attr_accessor :num_input_digits_max     # input number: digit amount
  attr_accessor :message_window_showing   # Ejecutando Ventana de Mensaje
  attr_accessor :common_event_id          # ID de Evento Común
  attr_accessor :in_battle                # Indica si estás en la batalla
  attr_accessor :battle_calling           # Llamada a la Batalla
  attr_accessor :battle_troop_id          # ID de Grupo de Enemigos
  attr_accessor :battle_can_escape        # Posibilidad de Escapar
  attr_accessor :battle_can_lose          # Posibilidad de perder batalla
  attr_accessor :battle_proc              # Llamada a Batalla (Proc)
  attr_accessor :battle_turn              # Número de turnos en la batalla
  attr_accessor :battle_event_flags       # battle event flags: completed
  attr_accessor :battle_abort             # Llamada para finalizar batalla
  attr_accessor :battle_main_phase        # battle flag: main phase
  attr_accessor :battleback_name          # Nombre del fondo de batalla
  attr_accessor :forcing_battler          # Combatiente forzado a una acción
  attr_accessor :shop_calling             # Llamada a Tienda
  attr_accessor :shop_goods               # Lista de objetos para la tienda
  attr_accessor :name_calling             # Llamada a Escribir Nombre
  attr_accessor :name_actor_id            # ID de Héroe para Escribir Nombre
  attr_accessor :name_max_char            # Máximo de carácteres para Escribir Nombre
  attr_accessor :menu_calling             # Llamada al Menú
  attr_accessor :menu_beep                # Reproducir sonido del menú
  attr_accessor :save_calling             # Llamada a Pantalla de Guardar
  attr_accessor :debug_calling            # Llamada a Pantalla de Depuración
  attr_accessor :player_transferring      # Llamada a Teletransportar Héroe
  attr_accessor :player_new_map_id        # Destino del Héroe: ID de Mapa
  attr_accessor :player_new_x             # Destino del Héroe: Cordenada X
  attr_accessor :player_new_y             # Destino del Héroe: Cordenada Y
  attr_accessor :player_new_direction     # Destino del Héroe: direction
  attr_accessor :transition_processing    # Llamada a Proceso de Transición
  attr_accessor :transition_name          # Nombre del Archivo de Transición
  attr_accessor :gameover                 # Llamada a GameOver
  attr_accessor :to_title                 # Llamada a Volver a Título
  attr_accessor :last_file_index          # Número de la última partida guardada
  attr_accessor :debug_top_row            # Pantalla de Depuración: Fila Elegida
  attr_accessor :debug_index              # Pantalla de Depuración: Opción Elegida
  #--------------------------------------------------------------------------
  # * Inicio de Objetos (Aquí se agrega el valor incial a cada variable)
  #--------------------------------------------------------------------------
  def initialize
    @map_bgm = nil
    @message_text = nil
    @message_proc = nil
    @choice_start = 99
    @choice_max = 0
    @choice_cancel_type = 0
    @choice_proc = nil
    @num_input_start = 99
    @num_input_variable_id = 0
    @num_input_digits_max = 0
    @message_window_showing = false
    @common_event_id = 0
    @in_battle = false
    @battle_calling = false
    @battle_troop_id = 0
    @battle_can_escape = false
    @battle_can_lose = false
    @battle_proc = nil
    @battle_turn = 0
    @battle_event_flags = {}
    @battle_abort = false
    @battle_main_phase = false
    @battleback_name = ''
    @forcing_battler = nil
    @shop_calling = false
    @shop_id = 0
    @name_calling = false
    @name_actor_id = 0
    @name_max_char = 0
    @menu_calling = false
    @menu_beep = false
    @save_calling = false
    @debug_calling = false
    @player_transferring = false
    @player_new_map_id = 0
    @player_new_x = 0
    @player_new_y = 0
    @player_new_direction = 0
    @transition_processing = false
    @transition_name = ""
    @gameover = false
    @to_title = false
    @last_file_index = 0
    @debug_top_row = 0
    @debug_index = 0
  end
end
