package com.ivanprokic.lambdademo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@AllArgsConstructor
@RestController
public class DemoController {

    @GetMapping(path = "/hello")
    public String sayHello() {
        log.info("Hello from Spring Boot Lambda");
        return "Hello from Spring Boot Lambda";
    }

}
