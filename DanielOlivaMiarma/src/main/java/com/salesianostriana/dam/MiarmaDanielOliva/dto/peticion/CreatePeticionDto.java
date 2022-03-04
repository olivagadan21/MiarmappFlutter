package com.salesianostriana.dam.MiarmaDanielOliva.dto.peticion;

import lombok.*;

import javax.persistence.Lob;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreatePeticionDto {

    @Lob
    private String texto;


}
