package com.salesianostriana.dam.MiarmaDanielOliva.repos;

import com.salesianostriana.dam.MiarmaDanielOliva.model.EstadoPublicacion;
import com.salesianostriana.dam.MiarmaDanielOliva.model.Publicacion;

import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserEntity;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface PublicacionRepository extends JpaRepository<Publicacion, Long> {


    Publicacion findByTitulo(String titulo);
    List<Publicacion> findByEstadoPublicacion(EstadoPublicacion estadoPublicacion);

    List<Publicacion> findByUser(UserEntity user);

    @EntityGraph(value = "Publicacion-UserEntity")
    List<Publicacion> findByUserId(UUID id);

    @EntityGraph(value = "Publicacion-UserEntity")
    List<Publicacion> findByUserNick(String nick);

    @Query("""
            SELECT p FROM Publicacion p
            WHERE p.estadoPublicacion = :estado
            AND p.user.nick = :nick
            """)
    List<Publicacion> aaa(@Param("estado") EstadoPublicacion estadoPublicacion, @Param("nick") String nick);

    boolean existsByTitulo(String titulo);



}
