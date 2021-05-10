@Istest
public with sharing class TEST_helloWorld {

    public TEST_helloWorld() {

    }

    @isTest
    private static void helloTest(){
        test.startTest();

        helloWorld hi = new helloWorld();

        Test.stopTest();
    }

}
