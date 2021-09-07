package com.example.lens;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Mat;
import java.util.Date;
import java.util.Arrays;
import java.util.ArrayList;

class Plugin{
    public static String foundVertices(String path){

        Point[] sorted = Plugin.foundPoints(path);
      try{
        return serializeRectangleData(sorted).toString();
      }catch (JSONException e){
        return null;
      }
    }

    public static Point[] foundPoints(String path){
        Mat source = ImgProcessing.loadImage(path);
        Mat resize = ImgProcessing.Resize(source);
        Mat gray = ImgProcessing.gray(resize);
        Mat blur = ImgProcessing.blur(gray);
        Mat dilate = ImgProcessing.dilate(blur);
        Mat canny = ImgProcessing.cannyEdgeDetect(dilate);
        Mat erode = ImgProcessing.dilate(canny);
        MatOfPoint2f unsortedPoints = ImgProcessing.countour(erode);
        Point[] sorted = ImgProcessing.sortedPoints(unsortedPoints);
        Point[] newSorted = new Point[4];
        int i = 0;
        for(Point po: sorted){
          Point temp = new Point(po.x/resize.cols(), po.y/resize.rows());
          newSorted[i] = temp;
          i++;
        }
        return newSorted;
    }

    public static String bw(String path){
        Mat orig = ImgProcessing.loadImage(path);
        Mat gray = ImgProcessing.cannyEdgeDetect(orig);
        //String savePath = System.getProperty("java.io.tmpdir") + "/pocketImg" + new Date().getTime() + ".png";
        String savePath = ImgProcessing.saveImg(gray);
        return savePath;
    }

    public static String crop(String path){
      Mat source = ImgProcessing.loadImage(path);
      Point[] vertices = Plugin.foundPoints(path);
      Mat warped = ImgProcessing.warp(source, vertices);
      //String savePath = System.getProperty("java.io.tmpdir") + "/pocketImg" + new Date().getTime() + ".png";
      String savePath = ImgProcessing.saveImg(warped);
      return savePath;
  }

    public static String autoCrop(String path){
      Mat source = ImgProcessing.loadImage(path);
      Point[] points = Plugin.foundPoints(path);
      Mat crop =  ImgProcessing.warp(source, points);   
      Mat magic = ImgProcessing.magicColor(crop);
      //String savePath = System.getProperty("java.io.tmpdir") + "/pocketImg" + new Date().getTime() + ".png";
      String savePath = ImgProcessing.saveImg(magic);
      return savePath;
    }
  
    public static String customCrop(String path, ArrayList<Double> point, boolean scaned){
      Mat source = ImgProcessing.loadImage(path);
      Mat warped = ImgProcessing.customWarp(source, point);

      if(scaned){
        Mat magic = ImgProcessing.magicColor(warped);
        String savePath = ImgProcessing.saveImg(magic);
      return savePath;
      }else{
        String savePath = ImgProcessing.saveImg(warped);
        return savePath;
      }
      //String savePath = System.getProperty("java.io.tmpdir") + "/pocketImg" + new Date().getTime() + ".png";
      
    }

    private static JSONObject serializeRectangleData(Point[] approx) throws JSONException {
        JSONObject contour = new JSONObject();
        JSONArray points = new JSONArray();
    
        for (int i = 0; i < 4; i++) {
          Point t = approx[i];
          JSONObject o = new JSONObject();
          o.put("x", (t.x));
          o.put("y", (t.y));
    
          points.put(o);
        }    
        contour.put("points", points);
        return contour;
      }
}