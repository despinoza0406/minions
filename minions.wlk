class UserException inherits Exception { }
class Minions{
	var bananas
	var armas=[]
	var color
	var maldades=0
	
	constructor(b,a){
		bananas=b
		armas=a
		color = new Amarillo()
	}
	
	method agregarArma(arma){
		armas.add(arma)
	}
	
	method sumarBananas(cantBananas){
		bananas+=cantBananas
	}	
	
	method absorberSuero(){
		bananas-=1
		armas = color.absorberSuero(armas)
		color= color.cambioColor()
	}
	
	method nivelDeConcentracion(){
		return color.nivelDeConcentracion(bananas,armas)
	}
	
	method peligrosidad(){
		return color.medirPeligro(armas)
	}
	method poseeArma(armabuscar){
		return armas.any({arma=>arma.nombre()==armabuscar})
	}
	method bienAlimentado(){
		return bananas>100
	}
	method sumarMaldad(){
		maldades+=1
	}
	method maldades(){
		return maldades
	}

}

class Amarillo{
	
	
	method nivelDeConcentracion(bananas,armas){
		return self.armaMasPotente(armas) + bananas
	}
	method absorberSuero(_){

		return []
		
	}
	method armaMasPotente(armas){
		return (armas.map({a=>a.potenciaArma()})).max()
	}
	method cambioColor(){
		return new Violeta()
	}
	method medirPeligro(armas){
		return armas.size()>2
	}
	
}

class Violeta{
	
	method absorberSuero(armas){
		return armas
	}
	
	method nivelDeConcentracion(bananas,_){
		return bananas
	}
	
	method cambioColor(){
		return new Amarillo()
	}
	
	method medirPeligro(_){
		return true
	}
	
}

class Armas{
	var nombre=""
	var potencia
	
	constructor (nombreA,potenciaA){
		nombre=nombreA
		potencia=potenciaA
	}
	method potenciaArma(){
		return potencia
	}
	method nombre(){
		return nombre
	}
}

class Villano {
	var minions=[]
	
	var ciudad
	constructor(lugar){
		ciudad=lugar
	}
	method nuevoMinion(){
		minions.add(new Minions(5,new Armas("RayoCongelante",10)))
	}
	method otorgarArma(nombre,potencia,minion){
		minion.agregarArma(new Armas(nombre,potencia))
	}
	method alimentar(cantBananas,minion){
		minion.sumarBananas(cantBananas)
	}
	method concentracionDeMinion(minion){
		return minion.nivelDeConsentracion()
	}
	method esPeligroso(minion){
		return minion.peligrosidad()
	}
	method planificarMaldad(crimen,artefacto){	
		crimen.efectuarMaldad(ciudad,minions,artefacto)
	}
	method minionMasUtil(){
		return minions.max({minion=>minion.maldades()})
	}
	method minionsInutiles(){
		return minions.filter({minion=>minion.maldades() == 0})
	}
	
}

class Ciudad{
	var temperatura
	var cosas=[]
	
	constructor(tem,cos){
		temperatura=tem
		cosas=cos
	}
	method bajarTemperatura(cant){
		temperatura-=cant
	}
	method robarArtefacto(artefacto){
		cosas.remove({artefacto})
	}
	
}
object congelar{
	var arma="RayoCongelante"
	var concentracionRequerida = 500
	method minionsCalificados(minions){
		return minions.filter({m=>m.poseeArma(arma) && m.nivelDeConcentracion()>= concentracionRequerida })
	}
	method efectuarMaldad(ciudad,minions,_){
			if(self.minionsCalificados(minions) == []){throw new UserException("No hay minions calificados")}
			else
			self.recompensarMinions(self.minionsCalificados(minions))
			ciudad.bajarTemperatura(30)
		
	}
	method recompensarMinions(minions){
		minions.forEach({minion=>minion.sumarBananas(10) minion.sumarMaldad()})
	}
	method modificarConcentracionRequerida(nuevaConcentracion){
		concentracionRequerida = nuevaConcentracion
	}
	
}

object robar{
	method efectuarMaldad(ciudad,minions,artefacto){
		if(artefacto.minionsCalificados(minions) == []){throw new UserException("No hay minions calificados")}
		artefacto.recompensarMinions(artefacto.minionsCalificados(minions),ciudad)
		ciudad.robarArtefacto(artefacto)
	}
}


class Piramide{
	var altura
	
	constructor(alto){
		altura=alto
	}
	method minionsCalificados(minions){
		return minions.filter({minion=>minion.nivelDeConcentracion()>=(altura/2)})
	}
	method recompensarMinions(minions,_){
		minions.forEach({minion=>minion.sumasBananas(10)  minion.sumarMaldad()})

	}
}

class SueroMutante{
	
	method minionsCalificados(minions){
		return minions.filter({minion=>minion.nivelDeConcentracion()>=23 && minion.bienAlimentado()})
	}
	method recompensarMinions(minions,_){
		minions.forEach({minion=>minion.absorberSuero()  minion.sumarMaldad()})
	}
}

object luna{
	var arma="RayoEncogedor"
	
	method minionsCalificados(minions){
		return minions.filter({minion=>minion.poseeArma(arma)})
	}
	method recompensarMinions(minions,ciudad){
		minions.forEach({minion=>minion.agregarArma(new Armas("RayoCongelante",10)) minion.sumarMaldad()})
		ciudad.bajarTemperatura(15)
	}
}


/* a) Si necesitaramos que de ser violeta pasara a ser verde y de verde a amarillo, cambiariamos el metodo cambio color
 * y absorber suero en la clase violeta como sea conveniente
 * class Violeta{
	
	method absorberSuero(armas){
		return armas
	}
	
	method nivelDeConcentracion(bananas,_){
		return bananas
	}
	
	method cambioColor(){
		return new Verde()
	}
	
	method medirPeligro(_){
		return true
	}
}
	* 
	*  Un minion verde al pasar a amarillo devuelve las 1ras 5 armas que tiene y nunca es peligroso
	* 
	class Verde{
	
	method absorberSuero(armas){
		return armas.take(5)
	}
	
	method nivelDeConcentracion(bananas,_){
		return bananas*15
	}
	
	method cambioColor(){
		return new Amarillo()
	}
	
	method medirPeligro(_){
		return false
	}
	
}	
 *Basicamente lo que hariamos seria agregar un nuevo estado al que pueden acceder los minions,
 *que posea un comportamiento diferente a los otros 2  

 * b) En el caso de que una vez que se vuelva violeta no pueda cambiar, significaria que simpre se quedaria asi, por lo cual
 * tendriamos que cambiar el metodo cambioColor() de esta manera
 *class Violeta{
	
	method absorberSuero(armas){
		return armas
	}
	
	method nivelDeConcentracion(bananas,_){
		return bananas
	}
	
	method cambioColor(){
		return self
	}
	
	method medirPeligro(_){
		return true
	}
	
} 
 */


