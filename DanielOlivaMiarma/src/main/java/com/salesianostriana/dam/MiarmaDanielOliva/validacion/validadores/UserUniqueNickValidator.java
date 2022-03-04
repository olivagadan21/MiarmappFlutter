package com.salesianostriana.dam.MiarmaDanielOliva.validacion.validadores;
import com.salesianostriana.dam.MiarmaDanielOliva.users.repos.UserEntityRepository;
import com.salesianostriana.dam.MiarmaDanielOliva.validacion.anotaciones.UserUniqueNick;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class UserUniqueNickValidator implements ConstraintValidator<UserUniqueNick, String> {

    @Autowired
    private UserEntityRepository userEntityRepository;

    @Override
    public void initialize(UserUniqueNick constraintAnnotation){}
    @Override
    public boolean isValid(String s, ConstraintValidatorContext constraintValidatorContext) {
        return StringUtils.hasText(s) && !userEntityRepository.existsByNick(s);
    }
}
