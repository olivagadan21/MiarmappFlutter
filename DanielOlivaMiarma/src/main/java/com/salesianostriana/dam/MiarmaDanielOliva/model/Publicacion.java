package com.salesianostriana.dam.MiarmaDanielOliva.model;

import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserEntity;
import lombok.*;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;

@Entity
@NoArgsConstructor@AllArgsConstructor
@Getter@Setter
@Builder
@NamedEntityGraph(
        name = "Publicacion-UserEntity",attributeNodes = {
        @NamedAttributeNode("user"),
}
)
public class Publicacion implements Serializable {

    @Id
    @GeneratedValue
    private Long id;

    private String titulo;

    private String texto;

    private String file;


    private LocalDate fechaPublicacion;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado")
    private EstadoPublicacion estadoPublicacion;

    @ManyToOne
    private UserEntity user;



    //Comentarios Ampliación
    /*@OneToMany(mappedBy = "comentario")
    private List<Comentario> comentarios = new ArrayList<>();*/

}
