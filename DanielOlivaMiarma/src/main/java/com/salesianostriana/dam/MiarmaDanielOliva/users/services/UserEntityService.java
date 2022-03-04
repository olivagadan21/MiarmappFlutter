package com.salesianostriana.dam.MiarmaDanielOliva.users.services;

import com.salesianostriana.dam.MiarmaDanielOliva.dto.peticion.CreatePeticionDto;
import com.salesianostriana.dam.MiarmaDanielOliva.dto.peticion.PeticionDtoConverter;
import com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones.*;
import com.salesianostriana.dam.MiarmaDanielOliva.model.PeticionSeguimiento;
import com.salesianostriana.dam.MiarmaDanielOliva.repos.PeticionSeguimientoRepository;
import com.salesianostriana.dam.MiarmaDanielOliva.repos.PublicacionRepository;
import com.salesianostriana.dam.MiarmaDanielOliva.services.PeticionService;
import com.salesianostriana.dam.MiarmaDanielOliva.services.StorageService;
import com.salesianostriana.dam.MiarmaDanielOliva.services.base.BaseService;
import com.salesianostriana.dam.MiarmaDanielOliva.users.dto.*;
import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserEntity;
import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserRoles;
import com.salesianostriana.dam.MiarmaDanielOliva.users.repos.UserEntityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.FileNotFoundException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@Service("userDetailService")
@RequiredArgsConstructor
public class UserEntityService extends BaseService<UserEntity, UUID, UserEntityRepository> implements UserDetailsService {

    private final PasswordEncoder passwordEncoder;
    private final StorageService storageService;
    private final PeticionService peticionService;
    private final UserEntityRepository userEntityRepository;
    private final UserDtoConverter userDtoConverter;
    private final PeticionSeguimientoRepository peticionSeguimientoRepository;
    private final PeticionDtoConverter peticionDtoConverter;
    private final PublicacionRepository publicacionRepository;


    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return this.repository.findFirstByEmail(email).orElseThrow(() -> new UsernameNotFoundException(email + " no encontrado"));
    }

    public List<UserEntity> loadUserByRole(UserRoles userRoles) throws UsernameNotFoundException {
        return this.repository.findByUserRoles(userRoles).orElseThrow(() -> new UsernameNotFoundException(userRoles + " no encontrado"));
    }

    public UserEntity loadUserById(UUID uuid) throws UsernameNotFoundException {
        return this.repository.findById(uuid).orElseThrow(() -> new UsernameNotFoundException(uuid + " no encontrado"));
    }


    public UserEntity saveUser(CreateUserDto userDto, MultipartFile file) throws Exception {

        List<String> extensiones = Arrays.asList("png", "gif", "jpg", "svg");

        String archivo = StringUtils.cleanPath(file.getOriginalFilename());

        String extension = StringUtils.getFilenameExtension(archivo);
        if (file.isEmpty()) {
            throw new FileNotFoundException();
        } else if (extensiones.contains(extension)) {

            String filename = storageService.escalar(file, 128);

            String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path("/download/")
                    .path(filename)
                    .toUriString();

            if (userDto.getPassword().equalsIgnoreCase(userDto.getPassword2())) {
                UserEntity userEntity = UserEntity.builder()
                        .nick(userDto.getNick())
                        .nombre(userDto.getNombre())
                        .apellidos(userDto.getApellidos())
                        .email(userDto.getEmail())
                        .fechaNacimiento(userDto.getFechaNacimiento())
                        .avatar(uri)
                        .password(passwordEncoder.encode(userDto.getPassword()))
                        .userRoles(userDto.isRol() ? UserRoles.PUBLICO : UserRoles.PRIVADO)
                        .build();
                return save(userEntity);
            } else {
                throw new UserEntityException("Las contraseñas no coinciden");
            }

        } else {
            throw new UnsupportedMediaTypeException(extensiones, MultipartFile.class);
        }

    }

    public List<PeticionSeguimiento> findAllPeticiones() {

        List<PeticionSeguimiento> data = peticionSeguimientoRepository.findAll();
        if (data.isEmpty()) {
            throw new ListEntityNotFoundException(PeticionSeguimiento.class);
        }

        return peticionService.findAll();

    }

    public Optional<GetUserDto> actualizarPerfil(UserEntity user, CreateUserDtoEdit u, MultipartFile file) throws Exception {

        List<String> extensiones = Arrays.asList("png", "gif", "jpg", "svg");

        String archivo = StringUtils.cleanPath(file.getOriginalFilename());

        String extension = StringUtils.getFilenameExtension(archivo);

        if (file.isEmpty()) {

            Optional<UserEntity> data = userEntityRepository.findById(user.getId());

            if (data.isEmpty()) {
                throw new SingleEntityNotFoundException(user.getId().toString(), UserEntity.class);
            }

            return data.map(m -> {
                m.setNombre(u.getNombre());
                m.setApellidos(user.getApellidos());
                m.setUserRoles(u.isRol() ? UserRoles.PUBLICO : UserRoles.PRIVADO);
                m.setNick(u.getNick());
                m.setAvatar(m.getAvatar());
                m.setEmail(u.getEmail());
                userEntityRepository.save(m);
                return userDtoConverter.UserEntityToGetUserDto(m);
            });

        } else if (extensiones.contains(extension)){

            Optional<UserEntity> data = userEntityRepository.findById(user.getId());

            if (data.isEmpty()) {
                throw new SingleEntityNotFoundException(user.getId().toString(), UserEntity.class);
            }

            String name = StringUtils.cleanPath(String.valueOf(data.get().getAvatar())).replace("http://localhost:8080/download/", "")
                    .replace("%20", " ");

            Path pa = storageService.load(name);

            String filename = StringUtils.cleanPath(String.valueOf(pa)).replace("http://localhost:8080/download/", "")
                    .replace("%20", " ");

            Path path = Paths.get(filename);

            storageService.deleteFile(path);

            String avatar = storageService.escalar(file, 128);


            String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path("/download/")
                    .path(avatar)
                    .toUriString();

            return data.map(m -> {
                m.setNombre(u.getNombre());
                m.setApellidos(user.getApellidos());
                m.setUserRoles(u.isRol() ? UserRoles.PUBLICO : UserRoles.PRIVADO);
                m.setNick(u.getNick());
                m.setAvatar(uri);
                m.setEmail(u.getEmail());
                userEntityRepository.save(m);
                return userDtoConverter.UserEntityToGetUserDto(m);
            });

        }else {
            throw new UnsupportedMediaTypeException(extensiones, MultipartFile.class);
        }
    }


    public PeticionSeguimiento solicitud(UserEntity userLogeado, CreatePeticionDto createPeticionDto, String nick) {

        UserEntity userBuscado = userEntityRepository.findByNick(nick);

        if (userBuscado != null && !userBuscado.getNick().equals(userLogeado.getNick())) {

            PeticionSeguimiento peticion = PeticionSeguimiento.builder()
                    .texto(createPeticionDto.getTexto() + userLogeado.getNick())
                    .destinatario(userBuscado)
                    .remitente(userLogeado)
                    .build();

            userBuscado.addPeticion(peticion);
            userEntityRepository.save(userBuscado);
            peticionSeguimientoRepository.save(peticion);

            return peticion;
        } else {
            throw new UserEntityException("No puedes enviar una petición de seguimiento a tu propio perfil");
        }
    }

    public void aceptarSolicitud(UserEntity userLogeado, Long id) {
        Optional<PeticionSeguimiento> peticion = peticionSeguimientoRepository.findById(id);

        if (peticion.isEmpty()) {
            throw new SingleEntityNotFoundException(id.toString(), PeticionSeguimiento.class);
        }
        userLogeado.addFollower(peticion.get().getRemitente());
        userEntityRepository.save(userLogeado);

        peticion.get().nullearDestinatarios();
        peticionSeguimientoRepository.save(peticion.get());
        peticionSeguimientoRepository.deleteById(id);

    }

    public void rechazarPeticion(Long id) {
        Optional<PeticionSeguimiento> peticionSeguimiento = peticionSeguimientoRepository.findById(id);

        if (peticionSeguimiento.isEmpty()) {
            throw new SingleEntityNotFoundException(id.toString(), PeticionSeguimiento.class);
        }

        peticionSeguimiento.get().nullearDestinatarios();

        peticionSeguimientoRepository.save(peticionSeguimiento.get());
        peticionSeguimientoRepository.deleteById(id);
    }

    public GetUserDtoWithPost verPerfilDeUsuario(UUID id) {

        Optional<UserEntity> userEntity = userEntityRepository.findById(id);


        if (!userEntity.isPresent()) {
            throw new SingleEntityNotFoundExceptionUUID(id, UserEntity.class);
        } else {
            return userDtoConverter.UserEntityToGetUserDtoWithPosts(userEntity, publicacionRepository.findByUser(userEntity.get()));
        }


    }


}
