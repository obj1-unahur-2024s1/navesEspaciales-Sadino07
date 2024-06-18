/** First Wollok example */
class Nave{
	var velocidad = 0
	var direccion = 0
	var combustible
	
	method acelerar(cuanto) {
		velocidad = (velocidad + cuanto).min(100000)
	}
	method desacelerar(cuanto) {
		velocidad = (velocidad - cuanto).max(0)
	}
	method irHaciaElSol(){
		direccion = 10
	}
	method escaparDelSol(){
		direccion = -10
	}
	method ponerseParalelo(){
		direccion = 0
	}
	method acercarseUnPocoAlSol(){
		direccion = (direccion + 1).min(10)
	}
	method alejarseUnPocoDelSol(){
		direccion = (direccion - 1).max(-10)
	}
	method cargarCombustible(cuanto){
		combustible += cuanto
	}
	method descargarCombustible(cuanto){
		combustible = (combustible - cuanto).max(0)
	}
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method estaTranquila(){
		return (combustible >= 4000 && velocidad <= 12000 && self.adicionalTranquilidad())
	}
	method adicionalTranquilidad()
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar()
	method avisar()
	method estaDeRelajo(){
		return self.estaTranquila() && self.tienePocaActividad()
	}
	method tienePocaActividad()
}

class NavesBaliza inherits Nave{
	var colorDeBaliza = "amarilla"
	var cambioDeColor = false

	method cambiarColorDeBaliza(colorNuevo){
		colorDeBaliza = colorNuevo
		cambioDeColor = true
	}
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParalelo()
	}
	override method adicionalTranquilidad(){
		return colorDeBaliza != "rojo"
	}
	override method escapar(){
		self.irHaciaElSol()
	}
	override method avisar(){	
		self.cambiarColorDeBaliza("rojo")
	}
	override method tienePocaActividad(){
		return not cambioDeColor 
	}
}

class NavesDePasajeros inherits Nave{
	const cantidadDePasajeros = 0
	var racionesDeBebida
	var racionesDeComida
	var property racionesServidas = 0
	
	method cargarComida(cuanto){
		racionesDeComida += cuanto
	}
	method descargarComida(cuanto){
		racionesDeComida = (racionesDeComida - cuanto).max(0)
	}
	method cargarBebida(cuanto){
		racionesDeBebida += cuanto
	}
	method descargarBebida(cuanto){
		racionesDeBebida = (racionesDeBebida - cuanto).max(0)
	}
	override method prepararViaje(){
		super()
		self.cargarComida(4 * cantidadDePasajeros)
		self.cargarBebida(6 * cantidadDePasajeros)
		self.acercarseUnPocoAlSol()
	}
	override method escapar(){
		velocidad *= 2
	}
	override method avisar(){
		self.descargarBebida(2 * cantidadDePasajeros)
		self.descargarComida(4 * cantidadDePasajeros)
		self.racionesServidas(2 * cantidadDePasajeros)
	}
	override method tienePocaActividad(){
		return racionesServidas < 50
	}
	override method adicionalTranquilidad(){
		return true
	}				
}

class NavesDeCombate inherits Nave{
	var visible = true
	var misilesDesplegados = false
	const property mensajesEmitidos = []
	
	method ponerseVisible(){
		visible = true
	}
	method ponerseInvisible(){
		visible = false
	}
	method estaInvisible(){
		return not visible
	}
	method desplegarMisiles(){
		misilesDesplegados = true
	}
	method replegarMisiles(){
		misilesDesplegados = false
	}
	method misilesDesplegados(){
		return misilesDesplegados
	}
	method emitirMensaje(mensaje){
		return mensajesEmitidos.add(mensaje)
	}
	method primerMensajeEmitido(){
		return mensajesEmitidos.first()
	}
	method ultimoMensajeEmitido(){
		return mensajesEmitidos.last()
	}
	method esEscueta(){
		return mensajesEmitidos.all{mensaje => mensaje.length() < 30}		
	}
	method emitioMensaje(mensaje){
		return mensajesEmitidos.contains(mensaje)
	}
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitioMensaje("Saliendo en mision")
		self.cargarCombustible(30000)
	}	
	override method adicionalTranquilidad(){
		return ! misilesDesplegados 
	}
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar(){	
		return	self.emitirMensaje("amenaza recibida")
	}
	override method tienePocaActividad(){
		return self.esEscueta()
	}	
}

class NaveHospital inherits NavesDePasajeros{
	var property quirofanoPreparado = true
	
	override method estaTranquila(){
		return super() && quirofanoPreparado == false
	}	
	override method recibirAmenaza(){
		super()
		quirofanoPreparado = true
	}
}

class NaveDeCombateSigilosa inherits NavesDeCombate{

	override method adicionalTranquilidad(){
		return super() && not visible 	
	}
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()			
	}
}