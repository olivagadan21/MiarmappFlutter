package com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones;

public class PublicacionException extends EntityNotFoundException{

    public PublicacionException(String message) {
        super(message);
    }
}
