package uqbar.celulares.domain

import org.uqbar.commons.model.CollectionBasedHome
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable

@Observable
class HomeCelulares extends CollectionBasedHome<Celular> {

	new() {
		this.init
	}

	def void init() {
		this.create("Laura Iturbe", 88022202, getModelo("NOKIA LUMIA 625"), false)
		this.create("Julieta Passerini", 45636453, getModelo("NOKIA ASHA 501"), false)
		this.create("Debora Fortini", 45610892, getModelo("NOKIA ASHA 501"), true)
		this.create("Chiara Dodino", 68026976, getModelo("NOKIA ASHA 501"), false)
		this.create("Melina Dodino", 40989911, getModelo("LG OPTIMUS L3 II"), true)
	}

	def getModelo(String modeloDescripcion) {
		(ApplicationContext::instance.getSingleton(typeof(Modelo)) as HomeModelos).get(modeloDescripcion)
	}

	// ********************************************************
	// ** Altas y bajas
	// ********************************************************
	def void create(String pNombre, Integer pNumero, Modelo pModeloCelular, Boolean pRecibeResumenCuenta) {
		var celular = new Celular
		celular.nombre = pNombre
		celular.numero = pNumero
		celular.modeloCelular = pModeloCelular
		celular.recibeResumenCuenta = pRecibeResumenCuenta
		this.create(celular)
	}

	override void validateCreate(Celular celular) {
		celular.validar()
		validarClientesDuplicados(celular)
	}

	def void validarClientesDuplicados(Celular celular) {
		val numero = celular.getNumero
		if (!this.search(numero).isEmpty) {
			throw new UserException("Ya existe un celular con el número: " + numero)
		}
	}

	// ********************************************************
	// ** Búsquedas
	// ********************************************************
	def search(Integer numero) {
		this.search(numero, null)
	}

	/**
	 * Busca los celulares que coincidan con los datos recibidos. Tanto número como nombre pueden ser nulos,
	 * en ese caso no se filtra por ese atributo.
	 *
	 * Soporta búsquedas por substring, por ejemplo el celular (12345, "Juan Gonzalez") será contemplado por
	 * la búsqueda (23, "Gonza")
	 */
	def search(Integer numero, String nombre) {
		allInstances.filter[celular|this.match(numero, celular.getNumero) && this.match(nombre, celular.getNombre)].toList
	}

	def match(Object expectedValue, Object realValue) {
		if (expectedValue == null) {
			return true
		}
		if (realValue == null) {
			return false
		}
		realValue.toString().toLowerCase().contains(expectedValue.toString().toLowerCase())
	}

	override def getEntityType() {
		typeof(Celular)
	}

	override def createExample() {
		new Celular
	}

	override def getCriterio(Celular example) {
		null
	}

	/**
	 * Para el proyecto web - se mantiene la busqueda por Identificador
	 */
	override def searchById(int id) {
		allInstances.findFirst[celular|celular.getId.equals(id)]
	}

}
