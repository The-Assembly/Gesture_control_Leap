//importing libraries required for processing
//to communicate with arduino and for arduino to 
//controll the servos
import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

//leapmotion library will allow the processing sketch 
//to capture the motion tracking data from the leap
//motion controller
import com.leapmotion.leap.*;

Arduino arduino; //Make an object called "arduino" of the Arduino class

//pins and the corresponding finger that the servo is connected to
int indexMiddleServo = 3; //Index & Middle
int ringPinkyServo = 6; //Ring
int thumbServo = 9; //Thumb

Controller controller  =  new Controller();

//Setup
void setup()
{
    size(2000, 1050);
    background(255);
    //arduino = new Arduino(this, "COM12", 57600);
    
    //setting pinmodes for the digital pins on Arduino
    arduino.pinMode(indexMiddleServo, Arduino.SERVO);
    arduino.pinMode(ringPinkyServo, Arduino.SERVO);
    arduino.pinMode(thumbServo, Arduino.SERVO);
}

void draw() {
    //background color-Black
    background(0);
    
    //Setup to capture frames
    Frame frame  =  controller.frame();
    

    println(controller.isConnected());//Check if controller is connected
    println(frame.isValid());//Check if frame is valid    
    
    if(frame.isValid()){
    text( frame.hands().count() + " Hand Detected", 1000, 525 );
    text(frame.toString(),1000,625);
    }
    
    
    /* |||||||||||||||||||||||||| FINGERS |||||||||||||||||||||||||||| */
    //Loop through all the fingers
    for (Finger finger : frame.fingers()) {
       //Get finger type 
       Finger.Type fingerType  =  finger.type();
   
       //Get thumb
       Finger thumb = controller.frame().hands().get(0).fingers().get(0);  
       
       switch (fingerType){
          case TYPE_INDEX:
               
              //Metacarpal Bone; Get the direction
              Vector indexMetacarpalVector  =  finger.bone(Bone.Type.TYPE_METACARPAL).basis().getZBasis();
              
              //Distal Bone; Get the direction
              Vector indexDistalVector  =  finger.bone(Bone.Type.TYPE_DISTAL).basis().getZBasis();
              
              //Calculate the angle bewteen the metacarpal and distal bone; convert to degrees.
              float indexAngle  =  indexMetacarpalVector.angleTo(indexDistalVector) * 180/PI;

              //arduino.servoWrite doesn't support float, so convert and round to integer
              int indexAngleFinal = (int) indexAngle;
              
              //Print to console, the index final angle value
              println("INDEX: ", indexAngleFinal);
              
              //Write to the servo, the index final angle value
              arduino.servoWrite(indexMiddleServo, indexAngleFinal);  
            
              break;
             
           case TYPE_MIDDLE:
           
              //Metacarpal Bone; Get the direction
              Vector middleMetacarpalVector  =  finger.bone(Bone.Type.TYPE_METACARPAL).basis().getZBasis();
              
              //Distal Bone; Get the direction
              Vector middleDistalVector  =  finger.bone(Bone.Type.TYPE_DISTAL).basis().getZBasis();
              
              //Calculate the angle bewteen the metacarpal and distal bone; convert to degrees
              double middleAngle  =  middleMetacarpalVector.angleTo((middleDistalVector)) * 180/PI;
              
              //Ratio for middle finger
              float middleRatio = 1.2;
               
              //Mutliply the raw angle value by the ratio
              middleRatio *= middleAngle;
              
              //arduino.servoWrite doesn't support float, so convert and round to integer
              int middleAngleFinal = (int) middleRatio;
              
              //Print to console, the middle final angle value
              //println("MIDDLE: ", middleAngleFinal);
              
              //Write to the servo, the middle final angle vlue
              arduino.servoWrite(indexMiddleServo, middleAngleFinal);  
              
              break;
          
          case TYPE_RING:
               break;
          
          case TYPE_PINKY:    
              //Ratio for pinky finger
              //float pinkyRatio = 1.2;
              break;
                
          case TYPE_THUMB:
              
              //Distal Bone; Get the vector
              Vector distalVector = thumb.bone(Bone.Type.TYPE_DISTAL).basis().getZBasis();
              
              //Metacarpal Bone; Get the vector
              Vector metacarpalVector = finger.bone(Bone.Type.TYPE_METACARPAL).basis().getZBasis();
                          
              //Calculate the angle between the thumb proximal bone, to the thumb's metacarpal bone; convert to degrees
              float thumbAngle = distalVector.angleTo(metacarpalVector) * 180/PI;
              
              //Ratio for thumb angle
              float thumbRatio = 1.8;
              
              //Multiply the thumb raw angle by the ratio
              thumbRatio *= thumbAngle;
              
              //arduino.servoWrite doesn't support float, so convert and round to integer; subract 180 to have it start from 0
              //int opposableAngleFinal = (int) opposableRatio - 180;
              int thumbAngleFinal = (int) thumbRatio;
              
              //Print absolute value angle of thumb to console
              println("THUMB: ", Math.abs(thumbAngleFinal));
              
              //Write to the servo, the position of the thumb angle; use absolute value (convert negative to positive value)
              arduino.servoWrite(thumbServo, Math.abs(thumbAngleFinal));
            
              break;
       }
    }
}
