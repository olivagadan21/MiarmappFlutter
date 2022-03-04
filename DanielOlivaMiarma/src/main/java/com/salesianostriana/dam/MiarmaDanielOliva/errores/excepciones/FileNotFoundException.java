package com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones;

public class FileNotFoundException extends StorageException {

    public FileNotFoundException(String message) {
        super(message);
    }

    public FileNotFoundException(String message, Exception cause) {
        super(message, cause);
    }
}