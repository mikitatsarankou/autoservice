({
   openModal: function(component, event, helper) {
      component.set("v.isOpen", true);
   },
 
   closeModal: function(component, event, helper) {
      component.set("v.isOpen", false);
   },

})