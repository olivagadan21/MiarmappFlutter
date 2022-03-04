package com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion;

import com.salesianostriana.dam.MiarmaDanielOliva.model.EstadoPublicacion;
import com.salesianostriana.dam.MiarmaDanielOliva.model.Publicacion;
import com.salesianostriana.dam.MiarmaDanielOliva.users.dto.UserDtoConverter;
import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
@RequiredArgsConstructor
public class PublicacionDtoConverter {

private final UserDtoConverter userDtoConverter;

    public Publicacion createPublicacionDtoToPublicacion(CreatePublicacionDto p, String uri, UserEntity user){

        return Publicacion.builder()
                .titulo(p.getTitulo())
                .texto(p.getTexto())
                .file(uri)
                .fechaPublicacion(LocalDate.now())
                .estadoPublicacion(p.isEstadoPublicacion() ? EstadoPublicacion.PUBLICO : EstadoPublicacion.PRIVADO)
                .user(user)
                .build();

    }

    public GetPublicacionDto createPublicacionDtoToPublicacion2(Publicacion p){

        return GetPublicacionDto.builder()
                .id(p.getId())
                .titulo(p.getTitulo())
                .texto(p.getTexto())
                .file(p.getFile())
                .fechaPublicacion(LocalDate.now())
                .estadoPublicacion(p.getEstadoPublicacion())
                .user(userDtoConverter.UserEntityToGetUserDto(p.getUser()))
                .build();

    }



    public GetPublicacionDto PublicacionToGetPublicacionDto(Publicacion p){
        return GetPublicacionDto.builder()
                .id(p.getId())
                .titulo(p.getTitulo())
                .texto(p.getTexto())
                .file(p.getFile())
                .fechaPublicacion(p.getFechaPublicacion())
                .estadoPublicacion(p.getEstadoPublicacion())
                .user(userDtoConverter.UserEntityToGetUserDto(p.getUser()))
                .build();
    }






}
