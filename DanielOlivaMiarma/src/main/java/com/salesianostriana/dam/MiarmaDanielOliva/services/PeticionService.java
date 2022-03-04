package com.salesianostriana.dam.MiarmaDanielOliva.services;

import com.salesianostriana.dam.MiarmaDanielOliva.errores.excepciones.ListEntityNotFoundException;
import com.salesianostriana.dam.MiarmaDanielOliva.model.PeticionSeguimiento;
import com.salesianostriana.dam.MiarmaDanielOliva.repos.PeticionSeguimientoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PeticionService {

    private final PeticionSeguimientoRepository peticionSeguimientoRepository;


    public List<PeticionSeguimiento> findAll (){

        List<PeticionSeguimiento> data = peticionSeguimientoRepository.findAll();

        if (data.isEmpty()){
            throw new ListEntityNotFoundException(PeticionSeguimiento.class);
        }else{
            return data;
        }


    }




}
