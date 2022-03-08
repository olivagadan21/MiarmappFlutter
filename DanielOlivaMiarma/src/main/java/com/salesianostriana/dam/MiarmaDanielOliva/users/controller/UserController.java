package com.salesianostriana.dam.MiarmaDanielOliva.users.controller;

import com.salesianostriana.dam.MiarmaDanielOliva.dto.peticion.CreatePeticionDto;
import com.salesianostriana.dam.MiarmaDanielOliva.dto.peticion.GetPeticionDto;
import com.salesianostriana.dam.MiarmaDanielOliva.dto.peticion.PeticionDtoConverter;
import com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones.UserEntityException;
import com.salesianostriana.dam.MiarmaDanielOliva.model.PeticionSeguimiento;
import com.salesianostriana.dam.MiarmaDanielOliva.services.PeticionService;
import com.salesianostriana.dam.MiarmaDanielOliva.users.dto.*;
import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserEntity;
import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserRoles;
import com.salesianostriana.dam.MiarmaDanielOliva.users.repos.UserEntityRepository;
import com.salesianostriana.dam.MiarmaDanielOliva.users.services.UserEntityService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
@RequestMapping("/")
@CrossOrigin(origins = "http://localhost:4200")
public class UserController {

    private final UserEntityService userEntityService;
    private final UserDtoConverter userDtoConverter;
    private final PeticionService peticionService;
    private final PeticionDtoConverter peticionDtoConverter;
    private final UserEntityRepository userEntityRepository;

    @PostMapping("auth/register")
    public ResponseEntity<GetUserDto> nuevoUser(@Valid @RequestParam("nombre") String nombre,@Valid @RequestParam("apellidos") String apellidos,@Valid @RequestParam("nick") String nick, @RequestParam String fechaNacimiento,@Valid @RequestParam("rol") boolean rol,@Valid @RequestParam("password") String password,@Valid @RequestParam("password2") String password2,@Valid @RequestParam("email") String email, @RequestPart("file")MultipartFile file) throws Exception {

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-d");

        CreateUserDto createUserDto = CreateUserDto.builder()
                .nombre(nombre)
                .apellidos(apellidos)
                .nick(nick)
                .email(email)
                .fechaNacimiento(LocalDate.parse(fechaNacimiento, formatter))
                .rol(rol)
                .password(password)
                .password2(password2)
                .build();


        UserEntity usuario = userEntityService.saveUser(createUserDto, file);

            return ResponseEntity.status(HttpStatus.CREATED).body(userDtoConverter.UserEntityToGetUserDto(usuario));
    }

    @GetMapping("follow/list")
    public ResponseEntity<List<GetPeticionDto>> listaPeticiones(){
        if (peticionService.findAll().isEmpty()){
            return ResponseEntity.notFound().build();
        }else{
            List<GetPeticionDto> list = peticionService.findAll().stream()
                    .map(peticionDtoConverter::PeticionToGetPeticionDto)
                    .collect(Collectors.toList());
            return ResponseEntity.ok().body(list);
        }
    }

    @PutMapping("profile/me")
    public ResponseEntity<Optional<GetUserDto>> actualizarPerfil (@AuthenticationPrincipal UserEntity userEntity, @RequestPart("user") CreateUserDtoEdit createUserDto, @RequestPart("file")MultipartFile file) throws Exception {

       return ResponseEntity.ok(userEntityService.actualizarPerfil(userEntity, createUserDto, file));
    }

    @PostMapping("follow/{nick}")
    public ResponseEntity<GetPeticionDto> realizarPeticion (@PathVariable String nick, @RequestPart("peticion") CreatePeticionDto createPeticionDto, @AuthenticationPrincipal UserEntity user){

        PeticionSeguimiento peticionSeguimiento = userEntityService.solicitud(user, createPeticionDto,nick);

        return  ResponseEntity.status(HttpStatus.CREATED).body(peticionDtoConverter.PeticionToGetPeticionDto(peticionSeguimiento));

    }

    @PostMapping("follow/accept/{id}")
    public ResponseEntity<?> aceptarPeticion(@PathVariable Long id, @AuthenticationPrincipal UserEntity userEntity){

        if (id.equals(null)){
            throw new UserEntityException("No se puede encontrar la petición solicitada");
        }else {

            userEntityService.aceptarSolicitud(userEntity, id);
            return ResponseEntity.status(HttpStatus.CREATED).build();
        }

    }

    @PostMapping("follow/decline/{id}")
    public ResponseEntity<?> rechazarPeticion(@PathVariable Long id){

        if (id.equals(null)){
            //excepcion propia a cambiar
            throw new UserEntityException("No se puede encontrar la petición solicitada");
        }else {

            userEntityService.rechazarPeticion(id);
            return ResponseEntity.status(HttpStatus.CREATED).build();
        }

    }

    @GetMapping("profile/{id}")
    public ResponseEntity<GetUserDtoWithPost> verPerfilDeUsuario(@PathVariable UUID id, @AuthenticationPrincipal UserEntity user){

        Optional<UserEntity> userEntity = userEntityRepository.findById(id);
        UserEntity user1 = userEntityRepository.findByFollowersContains(user);

        if (userEntity.get().getUserRoles().equals(UserRoles.PUBLICO) || user1.getNick().equals(userEntity.get().getNick())){

           GetUserDtoWithPost getUserDtoWithFollowers = userEntityService.verPerfilDeUsuario(id);
            return ResponseEntity.ok().body(getUserDtoWithFollowers);

        }else {
            throw new UserEntityException("El usuario(userEntity) proporcionado por nick tiene su perfil privado y el usuario(@AuthenticationPrincipal user) solicitante no forma parte de sus seguidores");
        }

    }



}
