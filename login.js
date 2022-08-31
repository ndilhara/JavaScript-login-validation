 // This function is for resetting all form values

 function reset(){
           
    document.getElementById("registrationForm").reset();
} 


// This function is for validating form values and it will send true or false(with particular errors).

function validation(registrationForm){

    // Making constant variables for registration form values.

    const fName=registrationForm.firstName;
    const lName=registrationForm.lastName;
    const address=registrationForm.address;
    const gender=registrationForm.gender;
    const email=registrationForm.email;
    const mobile=registrationForm.mobile;
    const course=registrationForm.course;


    console.log(fName.value);
    console.log(lName.value);
    console.log(address.value);
    console.log(gender.value);
    console.log(email.value);
    console.log(mobile.value);
    console.log(course.value);


   
    //  This function is for checking if all fields are filled by the end user and whether those values are valid.

    if(checkThisForm(fName,lName,address,gender,email,mobile,course)){

        
        if (mobileNumber(mobile)){

            if(emailCheck(email)){
                alert("Registration is successfull!");
                return true;

            }
            return false;
        }
        return false;           
    }
    else{
       
        return false;
    }
    
}

    // This function is for checking if the given value is empty.

    function checkEmpty(value_, Description) {
        console.log(value_);
        if (value_ == "") {
            alert("You must enter a value for " + Description);
          
            return false;
        }
        else 
            
        
        return true;
        }

     //  This function is for checking if all fields are filled by the end user.    

    function checkThisForm(fName,lName,address,gender,email,mobile,course) {
        
                if (checkEmpty(fName.value,"First Name") == false)
                        
                        return false;

                else if(checkEmpty(lName.value, "LastName") == false)
                        return false;

                else if(checkEmpty(address.value, "Address") == false)
                        return false; 

                else if(checkEmpty(gender.value, "Gender") == false)
                        return false;    
                
                else if(checkEmpty(email.value, "E-mail") == false)
                        return false;
                
                else if(checkEmpty(mobile.value, "Mobile Number") == false)
                        return false;

                else if(checkEmpty(course.value, "Course") == false)
                        return false;

                else        
                    return true;
                    }    

         //  This function is for checking if the given mobile number is valid.           

        function mobileNumber(mobile){                          
               
                if(/^\d{10}$/.test(mobile.value)){                            
                
                    return true;
                }
                 
                
                alert("You have entered an invalid mobile number !");
                return false;

                
            }



        //  This function is for checking if the given email address is valid. 

        function emailCheck(email){

            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){

                            
                    return true;
            }

            alert("You have entered an invalid email address! ");
             return false;

        }    

