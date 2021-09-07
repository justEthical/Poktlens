package com.example.lens;

import org.opencv.core.Point;
import org.opencv.core.MatOfPoint2f;
import java.util.ArrayList;
import java.util.Arrays;

class PointHelper{
    public static Point[] sortedPoints(MatOfPoint2f points) {
        Point[] bindu =  points.toArray();
        ArrayList<Point> bottom = new ArrayList<>();
        ArrayList<Point> top = new ArrayList<>();

        Point[] p = new Point[4];
        
        for(int j=0; j<2; j++) {
            double max=-1;
            int x = 2;
            for(int i = 0; i<bindu.length; i++) {
                if(bindu[i].y>max) {
                    max = bindu[i].y;
                    x = i;
                    ;
                }
            }
            bottom.add(bindu[x]);
            bindu[x] = new Point(-1,-1);		  
        }
        
        for(Point po: bindu ) {
            if(po.y>-1) {
                top.add(po);
            }
        }
        
        if(top.get(0).x<top.get(1).x) {
            p[0]= top.get(0);
            p[1]= top.get(1);
        } else {
            p[0]= top.get(1);
            p[1]= top.get(0);
        }
        
        if(bottom.get(0).x<bottom.get(1).x) {
            p[2] = bottom.get(1);
            p[3] = bottom.get(0);
        } else {
            p[2] = bottom.get(0);
            p[3] = bottom.get(1);
        }
        
        for(Point x: p) {
            System.out.println("X: "+ x.x + "Y: " + x.y);
        }
        
        return p;
    }
}