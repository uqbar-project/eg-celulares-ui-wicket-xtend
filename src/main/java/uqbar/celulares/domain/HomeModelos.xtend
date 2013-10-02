package uqbar.celulares.domain

import java.math.BigDecimal
import java.util.List
import org.uqbar.commons.model.CollectionBasedHome
import org.uqbar.commons.utils.Observable

@Observable
class HomeModelos extends CollectionBasedHome<Modelo> {

	new() {
		this.init
	}

	def void init() {
		this.create("NOKIA ASHA 501", 700f, true)
		this.create("LG OPTIMUS L5 II", 920f, false)
		this.create("LG OPTIMUS L3 II", 450f, true)
		this.create("NOKIA LUMIA 625", 350f, true)
		this.create("MOTOROLA RAZR V3", 350f, false)
	}
	
	def void create(String descripcion, float costo, boolean requiereResumenCuenta) {
		var modelo = new Modelo
		modelo.descripcion = descripcion
		modelo.costo = new BigDecimal(costo)
		modelo.requiereResumenCuenta = requiereResumenCuenta
		this.create(modelo)
	}

	def List<Modelo> getModelos() {
		allInstances	
	}
	
	def Modelo get(String descripcion) {
		getModelos.findFirst [ modelo | modelo.getDescripcion.equals(descripcion) ]
	}

	override def Class<Modelo> getEntityType() {
		typeof(Modelo)
	}

	override def createExample() {
		new Modelo()
	}

	override def getCriterio(Modelo example) {
		null
	}
	
}