package com.salesianostriana.dam.MiarmaDanielOliva.services;


import com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion.CreatePublicacionDto;
import com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion.GetPublicacionDto;
import com.salesianostriana.dam.MiarmaDanielOliva.dto.publicacion.PublicacionDtoConverter;
import com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones.ListEntityNotFoundException;
import com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones.PublicacionException;
import com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones.SingleEntityNotFoundException;
import com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones.UserEntityException;
import com.salesianostriana.dam.MiarmaDanielOliva.model.EstadoPublicacion;
import com.salesianostriana.dam.MiarmaDanielOliva.model.PeticionSeguimiento;
import com.salesianostriana.dam.MiarmaDanielOliva.model.Publicacion;
import com.salesianostriana.dam.MiarmaDanielOliva.repos.PublicacionRepository;
import com.salesianostriana.dam.MiarmaDanielOliva.users.model.UserEntity;
import com.salesianostriana.dam.MiarmaDanielOliva.users.repos.UserEntityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PublicacionService{

    private final PublicacionRepository publicacionRepository;
    private final StorageService storageService;
    private final PublicacionDtoConverter publicacionDtoConverter;
    private final PeticionService peticionService;
    private final UserEntityRepository userEntityRepository;


    public Publicacion crearPublicacion (CreatePublicacionDto createPublicacionDto, MultipartFile file, UserEntity user) throws Exception {

        List<String> videoExtension = Arrays.asList("webm","mkv","flv","vob","ogv","ogg",
                "rrc","gifv","mng","mov","avi","qt","wmv","yuv","rm","asf","amv","mp4","m4p","m4v","mpg","mp2","mpeg","mpe",
                "mpv","m4v","svi","3gp","3gpp","3g2","mxf","roq","nsv","flv","f4v","f4p","f4a","f4b","mod");

        String filename = StringUtils.cleanPath(file.getOriginalFilename());

        String extension = StringUtils.getFilenameExtension(filename);

        if (videoExtension.contains(extension)){

            String original = storageService.storeOriginal(file);
            String escaledVideo = storageService.escaleVideo(file);
            String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path("/download/")
                    .path(escaledVideo)
                    .toUriString();

            return publicacionRepository.save(publicacionDtoConverter.createPublicacionDtoToPublicacion(createPublicacionDto, uri, user));

        }else{
            String original = storageService.storeOriginal(file);
            String resized = storageService.escalar(file, 1024);

            String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path("/download/")
                    .path(resized)
                    .toUriString();

            return publicacionRepository.save(publicacionDtoConverter.createPublicacionDtoToPublicacion(createPublicacionDto, uri, user));
        }


    }

    public List<Publicacion> findAllPublicaciones(){

        List<Publicacion> data = publicacionRepository.findByEstadoPublicacion(EstadoPublicacion.PUBLICO);

        if (data.isEmpty()){
            throw new ListEntityNotFoundException(Publicacion.class);
        }else{
            return data;
        }


    }

    public Optional<GetPublicacionDto> actualizarPublicacion (Long id, CreatePublicacionDto p, MultipartFile file, UserEntity user) throws Exception {

        Optional<Publicacion> data = publicacionRepository.findById(id);

        if (data.isPresent()) {


            List<String> videoExtension = Arrays.asList("webm", "mkv", "flv", "vob", "ogv", "ogg",
                    "rrc", "gifv", "mng", "mov", "avi", "qt", "wmv", "yuv", "rm", "asf", "amv", "mp4", "m4p", "m4v", "mpg", "mp2", "mpeg", "mpe",
                    "mpv", "m4v", "svi", "3gp", "3gpp", "3g2", "mxf", "roq", "nsv", "flv", "f4v", "f4p", "f4a", "f4b", "mod");

            String name = StringUtils.cleanPath(file.getOriginalFilename());

            String extension = StringUtils.getFilenameExtension(name);

            if (data.get().getUser().getNick().equals(user.getNick())){

            if (file.isEmpty()) {


                return data.map(m -> {
                    m.setTitulo(p.getTitulo());
                    m.setTexto(p.getTexto());
                    m.setEstadoPublicacion(p.isEstadoPublicacion() ? EstadoPublicacion.PUBLICO : EstadoPublicacion.PRIVADO);
                    m.setFechaPublicacion(LocalDate.now());
                    m.setFile(m.getFile());
                    publicacionRepository.save(m);
                    return publicacionDtoConverter.PublicacionToGetPublicacionDto(m);
                });

            } else if (!videoExtension.contains(extension)) {


                String name2 = StringUtils.cleanPath(String.valueOf(data.get().getFile())).replace("http://localhost:8080/download/", "")
                        .replace("%20", " ");

                Path pa = storageService.load(name2);

                String filename = StringUtils.cleanPath(String.valueOf(pa)).replace("http://localhost:8080/download/", "")
                        .replace("%20", " ");

                Path path = Paths.get(filename);

                storageService.deleteFile(path);

                String original = storageService.storeOriginal(file);
                String newFilename = storageService.escalar(file, 1024);

                String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                        .path("/download/")
                        .path(newFilename)
                        .toUriString();

                return data.map(m -> {
                    m.setTitulo(p.getTitulo());
                    m.setTexto(p.getTexto());
                    m.setEstadoPublicacion(p.isEstadoPublicacion() ? EstadoPublicacion.PUBLICO : EstadoPublicacion.PRIVADO);
                    m.setFechaPublicacion(LocalDate.now());
                    m.setFile(uri);
                    publicacionRepository.save(m);
                    return publicacionDtoConverter.PublicacionToGetPublicacionDto(m);
                });

            } else {

                String name2 = StringUtils.cleanPath(String.valueOf(data.get().getFile())).replace("http://localhost:8080/download/", "")
                        .replace("%20", " ");

                Path pa = storageService.load(name2);

                String filename = StringUtils.cleanPath(String.valueOf(pa)).replace("http://localhost:8080/download/", "")
                        .replace("%20", " ");

                Path path = Paths.get(filename);

                storageService.deleteFile(path);

                String original = storageService.storeOriginal(file);
                String newFilename = storageService.escaleVideo(file);

                String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                        .path("/download/")
                        .path(newFilename)
                        .toUriString();

                return data.map(m -> {
                    m.setTitulo(p.getTitulo());
                    m.setTexto(p.getTexto());
                    m.setEstadoPublicacion(p.isEstadoPublicacion() ? EstadoPublicacion.PUBLICO : EstadoPublicacion.PRIVADO);
                    m.setFechaPublicacion(LocalDate.now());
                    m.setFile(uri);
                    publicacionRepository.save(m);
                    return publicacionDtoConverter.PublicacionToGetPublicacionDto(m);
                });

            }
            }else {
                throw new PublicacionException("No eres el propietario de esta publicación");
            }

        }else {
            throw new SingleEntityNotFoundException(id.toString(), Publicacion.class);
        }
    }

    public Optional<Publicacion> findById (Long id){
        return publicacionRepository.findById(id);
    }
    public Publicacion save(Publicacion p){
        return publicacionRepository.save(p);
    }

    public void deletePublicacion(Long id, UserEntity user) throws IOException {



        Optional<Publicacion> data = publicacionRepository.findById(id);

        if (data.get().getUser().getNick().equals(user.getNick())){




        if (data.isEmpty()){
            throw new SingleEntityNotFoundException(id.toString(), Publicacion.class);
        }else {


            String name = StringUtils.cleanPath(String.valueOf(data.get().getFile())).replace("http://localhost:8080/download/", "")
                    .replace("%20", " ");

            Path pa = storageService.load(name);

            String filename = StringUtils.cleanPath(String.valueOf(pa)).replace("http://localhost:8080/download/", "")
                    .replace("%20", " ");

            Path path = Paths.get(filename);

            storageService.deleteFile(path);

            publicacionRepository.deleteById(id);
        }

        }else{
            throw new UserEntityException("No es el propietario de esta publicación");
        }



    }


    public List<GetPublicacionDto> findAllPublicationsOfLogedUser(UserEntity user){
        List<Publicacion> publicacionList= publicacionRepository.findAll();
        List<Publicacion> publicacionList1= publicacionRepository.findByUserId(user.getId());
        if(publicacionList.isEmpty() && publicacionList.isEmpty()){
            return Collections.EMPTY_LIST;
        }else{
            return publicacionList1.stream().map(publicacionDtoConverter::PublicacionToGetPublicacionDto).collect(Collectors.toList());
        }
    }

    public List<PeticionSeguimiento> findAllPeticiones (){

        return peticionService.findAll();

    }

    public GetPublicacionDto findOnePublicacion(Long id, UserEntity user){

        Optional<Publicacion> publicacion = publicacionRepository.findById(id);

        if (publicacion.isEmpty()){
            throw new SingleEntityNotFoundException(id.toString(), Publicacion.class);
        }else{
            UserEntity seguidor = userEntityRepository.findByFollowersContains(user);

            if (publicacion.get().getEstadoPublicacion().equals(EstadoPublicacion.PUBLICO) || publicacion.get().getUser().equals(seguidor)){

                return publicacionDtoConverter.PublicacionToGetPublicacionDto(publicacion.get());

            }else{
                throw new PublicacionException("La publicación es privada");
            }
        }



    }

    public List<GetPublicacionDto> findAllPublicationsOfUser(String nick, UserEntity user){

        List<Publicacion> publicacionList = publicacionRepository.findAll();
        List<Publicacion> publicacionList1 = publicacionRepository.findByUserNick(nick);
        List<Publicacion> publicacionList2 = publicacionRepository.aaa(EstadoPublicacion.PUBLICO, nick);
        UserEntity userEntity = userEntityRepository.findByNick(nick);
        UserEntity seguidor = userEntityRepository.findByFollowersContains(user);

        if(publicacionList.isEmpty() && publicacionList1.isEmpty() && publicacionList2.isEmpty()){
            return Collections.EMPTY_LIST;
        }else if (!userEntity.equals(seguidor)){

           return publicacionList2.stream().map(publicacionDtoConverter::PublicacionToGetPublicacionDto).collect(Collectors.toList());

        }else{
            return publicacionList1.stream().map(publicacionDtoConverter::PublicacionToGetPublicacionDto).collect(Collectors.toList());
        }

    }





}
