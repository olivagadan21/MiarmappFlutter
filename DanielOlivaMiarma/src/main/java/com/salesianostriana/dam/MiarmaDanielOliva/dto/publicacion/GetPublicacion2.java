package com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion;

import com.salesianostriana.dam.MiarmaDanielOliva.model.EstadoPublicacion;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GetPublicacion2 {

    private Long id;

    private String titulo;

    private String texto;

    private String file;

    private LocalDate fechaPublicacion;

    private EstadoPublicacion estadoPublicacion;

}
