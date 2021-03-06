package com.salesianostriana.dam.MiarmaDanielOliva.security.dto;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class JwtUsuarioResponse {

    private String id;
    private String nick;
    private String email;
    private String nombre;
    private String avatar;
    private String role;
    private String token;
}
