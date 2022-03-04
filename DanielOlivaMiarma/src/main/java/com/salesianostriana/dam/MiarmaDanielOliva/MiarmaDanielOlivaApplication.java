package com.salesianostriana.dam.MiarmaDanielOliva;

import com.salesianostriana.dam.MiarmaDanielOliva.config.StorageProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@EnableConfigurationProperties(StorageProperties.class)
@SpringBootApplication
public class MiarmaDanielOlivaApplication {

	public static void main(String[] args) {
		SpringApplication.run(MiarmaDanielOlivaApplication.class, args);
	}

}
