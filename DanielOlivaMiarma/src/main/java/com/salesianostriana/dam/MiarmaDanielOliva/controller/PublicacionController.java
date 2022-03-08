package com.salesianostriana.dam.MiarmaDanielOliva.controller;

import com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion.CreatePublicacionDto;
import com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion.GetPublicacionDto;
import com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion.PublicacionDtoConverter;
import com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones.ListEntityNotFoundException;
import com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones.SingleEntityNotFoundException;
import com.salesianostriana.dam.MiarmaDanielOliva.model.Publicacion;
import com.salesianostriana.dam.MiarmaDanielOliva.repos.PublicacionRepository;
import com.salesianostriana.dam.MiarmaDanielOliva.services.PublicacionService;
import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
@RequestMapping("/post")
@CrossOrigin(origins = "http://localhost:4200")
public class PublicacionController {


    private final PublicacionDtoConverter publicacionDtoConverter;

    private final PublicacionService publicacionService;

    private final PublicacionRepository publicacionRepository;


    @PostMapping("/")
    public ResponseEntity<GetPublicacionDto> createPublicacion(@RequestParam("titulo") String titulo, @RequestParam("texto") String texto, @RequestParam("estadoPublicacion") boolean estadoPublicacion, @RequestPart("file")MultipartFile file, @AuthenticationPrincipal UserEntity user) throws Exception {

        CreatePublicacionDto createPublicacionDto = CreatePublicacionDto.builder()
                .titulo(titulo)
                .texto(texto)
                .estadoPublicacion(estadoPublicacion)
                .build();

        publicacionService.crearPublicacion(createPublicacionDto, file, user);

        GetPublicacionDto publicacionDto = publicacionDtoConverter.PublicacionToGetPublicacionDto(publicacionRepository.findByTitulo(createPublicacionDto.getTitulo()));

        return ResponseEntity.status(HttpStatus.CREATED).body(publicacionDto);

    }

    @GetMapping("/public")
    public ResponseEntity<List<GetPublicacionDto>> findAllPublicaciones(){

        if (publicacionService.findAllPublicaciones().isEmpty()){
            throw new ListEntityNotFoundException(Publicacion.class);
        }else{
            List<GetPublicacionDto> list = publicacionService.findAllPublicaciones().stream()
                    .map(publicacionDtoConverter::createPublicacionDtoToPublicacion2)
                    .collect(Collectors.toList());
            return ResponseEntity.ok().body(list);
        }


    }

    @PutMapping("/{id}")
    public ResponseEntity<Optional<GetPublicacionDto>> updatePublicacion(@PathVariable Long id, @RequestPart("publicacion") CreatePublicacionDto createPublicacionDto, @RequestPart("file") MultipartFile file, @AuthenticationPrincipal UserEntity user) throws Exception {
        if (id.equals(null)){
            throw new SingleEntityNotFoundException(id.toString(), Publicacion.class);
        }else{
            return ResponseEntity.status(HttpStatus.OK)
                    .body(publicacionService.actualizarPublicacion(id, createPublicacionDto, file, user));
        }


    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePublicacion(@PathVariable Long id, @AuthenticationPrincipal UserEntity user) throws Exception {
        if (id.equals(null)){
            throw new SingleEntityNotFoundException(id.toString(), Publicacion.class);
        }else{

            publicacionService.deletePublicacion(id, user);

            return ResponseEntity.status(204).build();
        }
    }

    @GetMapping("/me")
    public ResponseEntity<List<GetPublicacionDto>> findAllPublicationsOfLogedUser(@AuthenticationPrincipal UserEntity user){

        List<GetPublicacionDto> publicaciones = publicacionService.findAllPublicationsOfLogedUser(user);

        if (publicaciones == Collections.EMPTY_LIST){
            throw new ListEntityNotFoundException(Publicacion.class);
        }else{
            return ResponseEntity.ok().body(publicaciones);
        }


    }

    @GetMapping("/{id}")
    public ResponseEntity<GetPublicacionDto> findOnePublicacion (@PathVariable Long id, @AuthenticationPrincipal UserEntity user){

        GetPublicacionDto publicacion = publicacionService.findOnePublicacion(id, user);


            return ResponseEntity.ok().body(publicacion);

    }

    @GetMapping("/")
    public ResponseEntity<List<GetPublicacionDto>> findAllPublicationOfUser (@RequestParam(value = "nick") String nick, @AuthenticationPrincipal UserEntity user){


        List<GetPublicacionDto> publicaciones = publicacionService.findAllPublicationsOfUser(nick, user);

        if (publicaciones == Collections.EMPTY_LIST){
            throw new ListEntityNotFoundException(Publicacion.class);
        }else{
            return ResponseEntity.ok().body(publicaciones);
        }

    }

}
