trigger OrderTrigger on Order (after update) {

    OrderService.updateAccountTurnOver(Trigger.new);

}