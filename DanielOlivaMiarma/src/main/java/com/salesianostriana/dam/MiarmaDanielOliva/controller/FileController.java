package com.salesianostriana.dam.MiarmaDanielOliva.controller;

import com.salesianostriana.dam.MiarmaDanielOliva.services.StorageService;
import com.salesianostriana.dam.MiarmaDanielOliva.utils.MediaTypeUrlResource;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class FileController {

    private final StorageService storageService;


    

    @GetMapping("/download/{filename:.+}")
    public ResponseEntity<Resource> getFile(@PathVariable String filename) {
        MediaTypeUrlResource resource = (MediaTypeUrlResource) storageService.loadAsResource(filename);


        return ResponseEntity.status(HttpStatus.OK)
                .header("content-type", resource.getType())
                .body(resource);


    }

}
