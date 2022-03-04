package com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones;

public class UserEntityException extends EntityNotFoundException{

    public UserEntityException(String message) {
        super(message);
    }
}
