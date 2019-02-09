import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;
import com.leapmotion.leap.*;

Arduino arduino;

//Thumb
int thumbServo = 10;
//Index
int indexServo = 9;
//Middle
int middleServo = 5;
//Ring and Pinky
int ringServo = 6;
//Wrist
int pinkyServo = 3;

//Setup LeapMotion Controller
Controller controller  =  new Controller();

//Setup
void setup()
{
  //Size of data/image
  size(2000, 1050);
  
  //Background color
  background(255);
  
  //Setup the servos and serial communication
  //arduino = new Arduino(this, "COM11", 57600);
  arduino.pinMode(thumbServo, Arduino.SERVO);
  arduino.pinMode(indexServo, Arduino.SERVO);
  arduino.pinMode(middleServo, Arduino.SERVO);
  arduino.pinMode(pinkyServo, Arduino.SERVO);
  arduino.pinMode(ringServo, Arduino.SERVO);

}

void draw() {
    //background color
    background(0);
    
    //Setup to capture frames
    Frame frame  =  controller.frame();
    
    println(frame.isValid());
    
    if(frame.isValid()){
    text( frame.hands().count() + " Hand Detected", 1000, 525 );
    text(frame.toString(),1000,625);
    }
    
    /* |||||||||||||||||||||||||| FINGERS |||||||||||||||||||||||||||| */
    //Loop through all the fingers
    for (Finger finger : frame.fingers()) {
        //Get finger type
         Finger.Type fingerType  =  finger.type();
         
         //Get index finger
         Finger index = controller.frame().hands().get(0).fingers().get(1);
         
         //Get thumb
         Finger thumb = controller.frame().hands().get(0).fingers().get(0);
  
    
         switch (fingerType)
         {
           case TYPE_THUMB:
              
              //Distal Bone; Get the vector
              Vector distalVector = thumb.bone(Bone.Type.TYPE_DISTAL).basis().getZBasis();
              
              //Metacarpal Bone; Get the vector
              Vector metacarpalVector = finger.bone(Bone.Type.TYPE_METACARPAL).basis().getZBasis();
            
              //Ring Finger Metacarpal Bone; Get the vector
              Vector index_metacarpalVector  =  index.bone(Bone.Type.TYPE_DISTAL).basis().getZBasis();
                         
              //Calculate the angle between the thumb proximal bone, to the thumb's metacarpal bone; convert to degrees
              float thumbAngle = distalVector.angleTo(metacarpalVector) * 180/PI;
              
              //Ratio for thumb angle
              float thumbRatio = 1.8;
              
              //Multiply the thumb raw angle by the ratio
              thumbRatio *= thumbAngle;
              
              //arduino.servoWrite doesn't support float, so convert and round to integer; subract 180 to have it start from 0
              int thumbAngleFinal = (int) thumbRatio;
                            
              //Print absolute value angle of thumb to console
              println("THUMB: ", Math.abs(thumbAngleFinal));
               
              //Write to the servo, the position of the thumb angle; use absolute value (convert negative to positive value)
              arduino.servoWrite(thumbServo, Math.abs(thumbAngleFinal));
            
              break;
          
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
              arduino.servoWrite(indexServo, indexAngleFinal);  
            
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
              println("MIDDLE: ", middleAngleFinal);
              
              //Write to the servo, the middle final angle vlue
              arduino.servoWrite(middleServo, middleAngleFinal);  
              
              break;

           case TYPE_RING:
           
               //Metacarpal Bone; Get the direction
               Vector ringMetacarpalVector  =  finger.bone(Bone.Type.TYPE_METACARPAL).basis().getZBasis();
              
               //Distal Bone; Get the direction
               Vector ringDistalVector  =  finger.bone(Bone.Type.TYPE_DISTAL).basis().getZBasis();
              
               //Calculate the angle bewteen the metacarpal and distal bone; convert to degrees
               float ringAngle  =  ringMetacarpalVector.angleTo(ringDistalVector) * 180/PI;
                
               //arduino.servoWrite doesn't support float, so convert and round to integer
               int result4 = (int) ringAngle;
              
               println("RING: ", result4);
              
               arduino.servoWrite(ringServo, result4);  
               delay(5);
              
               break;          
           
           case TYPE_PINKY:
           
             //Metacarpal Bone; Get the direction
              Vector pinkyMetacarpalVector  =  finger.bone(Bone.Type.TYPE_METACARPAL).basis().getZBasis();
              
              //Distal Bone; Get the direction
              Vector pinkyDistalVector  =  finger.bone(Bone.Type.TYPE_DISTAL).basis().getZBasis();
              
              //Calculate the angle bewteen the metacarpal and distal bone; convert to degrees
              float pinkyAngle  =  pinkyMetacarpalVector.angleTo(pinkyDistalVector) * 180/PI;
              
              //Ratio for pinky finger
              float pinkyRatio = 1.2;
              
              //Subract 180 from raw angle value to convert to 180 to 0
              pinkyRatio *= pinkyAngle;
               
              //arduino.servoWrite doesn't support float, so convert and round to integer
              int pinkyAngleFinal = (int) pinkyRatio;
              
              //Print to console, the final pinky angle
              println("PINKY: ", pinkyAngleFinal);
              
              //Write to the servo, the final pinky angle
              arduino.servoWrite(pinkyServo, pinkyAngleFinal);  

              break;
          default:
              break;
        } 
       
    }
}
