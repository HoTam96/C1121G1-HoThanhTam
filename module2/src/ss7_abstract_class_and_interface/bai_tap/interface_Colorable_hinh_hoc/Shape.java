package ss7_abstract_class_and_interface.bai_tap.interface_Colorable_hinh_hoc;

public class Shape {
    private String color;
    private boolean filled;

    public Shape(String color, boolean filled) {
        this.color = color;
        this.filled = filled;
    }

    public Shape(String color) {
        this.color = color;
    }

    public Shape() {
        this.color = "green";
        this.filled = true;
    }


    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public boolean isFilled() {
        return filled;
    }

    public void setFilled(boolean filled) {
        this.filled = filled;
    }

//    @Override
//    public String toString() {
//        return "A Shape with color of xxx and filled/not filled";
//    }

}