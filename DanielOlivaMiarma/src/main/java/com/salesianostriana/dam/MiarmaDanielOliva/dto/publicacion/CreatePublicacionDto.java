package com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion;


import javax.persistence.Lob;
import javax.validation.constraints.NotBlank;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreatePublicacionDto {


    private String titulo;

    @Lob
    private String texto;

    @NotBlank
    private String file;

    private boolean estadoPublicacion;





}
