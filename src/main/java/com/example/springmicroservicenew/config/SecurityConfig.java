package com.example.springmicroservicenew.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;

@Configuration
public class SecurityConfig {

    // Minimal security: HTTP Basic with one in-memory user.
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .authorizeRequests()
                .antMatchers("/swagger-ui/**", "/v2/api-docs", "/swagger-resources/**", "/swagger-ui.html", "/actuator/**").permitAll()
                .anyRequest().authenticated()
                .and()
            .httpBasic();

        return http.build();
    }

    @Bean
    public UserDetailsService users() {
        // NOTE: for a minimal example we use the convenience password encoder - not for production.
        UserDetails user = User.withDefaultPasswordEncoder()
                .username("user")
                .password("password")
                .roles("USER")
                .build();
        return new InMemoryUserDetailsManager(user);
    }
}
