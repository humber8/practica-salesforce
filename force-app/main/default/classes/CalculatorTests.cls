@istest
public with sharing class CalculatorTests {
    public CalculatorTests() {

    }


    @isTest
    static void testDivideByZero() {
        try {
            Decimal result = Calculator.divide(10, 0);
            System.assert(false, 'Se esperaba una CalculatorException al dividir por cero');
        } catch (Calculator.CalculatorException e) {
            System.assertEquals('You still can\'t divide by zero', e.getMessage(), 'Mensaje de excepción esperado');
        }
    }
}