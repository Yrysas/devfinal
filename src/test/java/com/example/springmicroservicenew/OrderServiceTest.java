package com.example.springmicroservicenew;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import com.example.springmicroservicenew.model.Order;
import com.example.springmicroservicenew.repository.OrderRepository;
import com.example.springmicroservicenew.service.OrderService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

public class OrderServiceTest {

    @InjectMocks
    private OrderService orderService;

    @Mock
    private OrderRepository orderRepository;

    private Order order;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        order = new Order();
        order.setId(1L);
        order.setOrderDate(LocalDate.parse("2023-10-01"));
        order.setTotalAmount(BigDecimal.valueOf(100.0));
    }

    @Test
    public void testCreateOrder() {
        when(orderRepository.save(any(Order.class))).thenReturn(order);
        Order createdOrder = orderService.createOrder(order);
        assertNotNull(createdOrder);
        assertEquals(BigDecimal.valueOf(100.0), createdOrder.getTotalAmount());
    }

    @Test
    public void testGetOrderById() {
        when(orderRepository.findById(1L)).thenReturn(Optional.of(order));
        Optional<Order> foundOrder = orderService.getOrderById(1L);
        assertTrue(foundOrder.isPresent());
        assertEquals(BigDecimal.valueOf(100.0), foundOrder.get().getTotalAmount());
    }

    @Test
    public void testGetOrderById_NotFound() {
        when(orderRepository.findById(2L)).thenReturn(Optional.empty());
        Optional<Order> foundOrder = orderService.getOrderById(2L);
        assertFalse(foundOrder.isPresent());
    }
}
// }</content>
// <parameter name="filePath">c:/Users/yryss/Desktop/spring-microservice-new/src/test/java/com/example/springmicroservicenew/OrderServiceTest.java