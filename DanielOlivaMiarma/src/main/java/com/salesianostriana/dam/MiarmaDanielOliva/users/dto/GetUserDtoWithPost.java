package com.salesianostriana.dam.MiarmaDanielOliva.users.dto;

import com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion.GetPublicacion2;
import lombok.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GetUserDtoWithPost {

    private UUID id;
    private String nombre;
    private String apellidos;
    private String nick;
    private LocalDate fechaNacimiento;
    private String email;
    private String avatar;
    private String userRoles;
    private List<String> followers;
    private List<GetPublicacion2> publicaciones;
    private int peticiones;

}
