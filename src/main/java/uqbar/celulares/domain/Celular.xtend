package uqbar.celulares.domain

import org.uqbar.commons.model.Entity
import org.uqbar.commons.model.ObservableUtils
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.Observable

@Observable
class Celular extends Entity {

	final int MAX_NUMERO = 100000

	@Property Integer numero
	@Property String nombre
	@Property Modelo modeloCelular
	@Property Boolean recibeResumenCuenta = false
	
	// ********************************************************
	// ** Getters y setters
	// Los getters y setters por default no se deben codificar
	// peeeeeero...
	// en nuestro ejemplo tenemos que modificar la propiedad
	// recibeResumenCuenta en base al modelo de celular seleccionado
	// ********************************************************

	def void setModeloCelular(Modelo unModeloCelular) {
		this._modeloCelular = unModeloCelular

		recibeResumenCuenta = unModeloCelular.getRequiereResumenCuenta
		ObservableUtils::firePropertyChanged(this, "habilitaResumenCuenta", isHabilitaResumenCuenta())
	}

	// ********************************************************
	// ** Validacion
	// ********************************************************
	/**
	 * Valida que el celular esté correctamente cargado
	 */
	def validar() {
		if (getNumero == null) {
			throw new UserException("Debe ingresar número")
		}
		if (getNumero.intValue() <= this.MAX_NUMERO) {
			throw new UserException("El número debe ser mayor a " + this.MAX_NUMERO)
		}
		if (!this.ingresoNombre()) {
			throw new UserException("Debe ingresar nombre")
		}
		if (getModeloCelular == null) {
			throw new UserException("Debe ingresar un modelo de celular")
		}
	}

	def ingresoNombre() {
		 getNombre != null && !getNombre.trim().equals("")
	}

	// ********************************************************
	// ** Getters y setters
	// ********************************************************
	def isHabilitaResumenCuenta() {
		 !getModeloCelular.getRequiereResumenCuenta
	}
	
	// ********************************************************
	// ** Misceláneos
	// ********************************************************
	override def String toString() {
		var result = new StringBuffer
		result.append(getNombre ?: "Celular sin nombre")
		if (getModeloCelular != null) {
			result.append(" - " + getModeloCelular)
		}
		if (getNumero != null) {
			result.append(" - " + getNumero)
		}
		result.append(if (getRecibeResumenCuenta) " - recibe resumen" else " - no recibe resumen")
		result.toString
	}

}
