package com.salesianostriana.dam.MiarmaDanielOliva.validacion.anotaciones;



import com.salesianostriana.dam.MiarmaDanielOliva.validacion.validadores.UserUniqueNickValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UserUniqueNickValidator.class)
@Documented
public @interface UserUniqueNick {

    String message() default "El nommbre de usuario ya existe";

    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};

}
