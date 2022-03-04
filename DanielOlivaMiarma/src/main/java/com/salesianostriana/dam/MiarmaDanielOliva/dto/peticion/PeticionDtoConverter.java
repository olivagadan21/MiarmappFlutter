package com.salesianostriana.dam.MiarmaDanielOliva.dto.peticion;

import com.salesianostriana.dam.MiarmaDanielOliva.model.PeticionSeguimiento;
import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class PeticionDtoConverter {

    public GetPeticionDto PeticionToGetPeticionDto(PeticionSeguimiento p){

        return GetPeticionDto.builder()
                .id(p.getId())
                .texto(p.getTexto())
                .build();

    }

    public PeticionSeguimiento createPeticionDtoToPeticion(CreatePeticionDto createPeticionDto, UserEntity user2){

        return PeticionSeguimiento.builder()
                .texto(createPeticionDto.getTexto())
                .destinatario(user2)
                .build();

    }

}
