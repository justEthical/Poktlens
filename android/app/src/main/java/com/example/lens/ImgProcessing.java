package com.example.lens;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;

import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.MatOfPoint;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Size;
import org.opencv.imgproc.Imgproc;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import android.graphics.Bitmap;

import org.opencv.android.Utils;
import org.opencv.core.Mat;
import org.opencv.imgcodecs.Imgcodecs;

class ImgProcessing{
    
    static Mat kernel = Imgproc.getStructuringElement(Imgproc.MORPH_DILATE, new  Size((2*2) + 1, (2*2)+1));
    static Imgcodecs imageCodecs = new Imgcodecs();

    public static Mat loadImage(String path) {
        Mat source = new Mat();
        source = imageCodecs.imread(path);
        return source;
      }

    public static Mat blur(Mat source){
        Mat blur = new Mat();
        Imgproc.GaussianBlur(source, blur, new Size(5,5), 0 );
        return blur;
    }
    public static Mat gray(Mat source){
        Mat gray = new Mat();
        Imgproc.cvtColor(source, gray, Imgproc.COLOR_BGR2GRAY);
        return gray;
	}
	
	public static Mat magicColor(Mat path){

		//Mat source = ImgProcessing.loadImage(path);
		
		Scan scanner = new Scan(path, 51, 66, 150);
		Mat scannedImg = scanner.scanImage(Scan.ScanMode.GCMODE);

		Mat gray = new Mat();
		Imgproc.cvtColor(scannedImg, gray, Imgproc.COLOR_BGR2GRAY);

	/*	Mat adap = new Mat();
		Imgproc.adaptiveThreshold(gray, adap, 255, 0, 1, 7, 9);

		Mat bin = ImgProcessing.inversionThreshold(adap);
		
		Mat mb = new Mat();
		Imgproc.medianBlur(bin, mb, 1);  */

		return gray;
	}

    public static Mat Resize(Mat source){
        Mat resize = new Mat();
        Imgproc.resize(source, resize, new Size(800, 800));
        return resize;
    }

    public static Mat trreshold(Mat source) {
	    Mat destination = new Mat();
	    Imgproc.threshold(source, destination, 100, 255, Imgproc.THRESH_BINARY);
	    return destination;
	  }
	
	
	public static String saveImg(Mat matrix){
		String savePath = System.getProperty("java.io.tmpdir") + "/pocketImg" + new Date().getTime() + ".png"; 
		imageCodecs.imwrite(savePath, matrix);			
		System.out.println("write done");
		return savePath;
	}

	public static MatOfPoint2f countour(Mat source) {
		ArrayList<MatOfPoint> contours = new ArrayList<>();
	    Imgproc.findContours(
	        source,
	        contours,
	        new Mat(),
	        Imgproc.RETR_LIST,
	        Imgproc.CHAIN_APPROX_SIMPLE);
	    
	    double maxArea = 0;
	    MatOfPoint2f maxApprox = null;

	    for (int i = contours.size() - 1; i>=0; i--) {
	      MatOfPoint2f maxContour2f = new MatOfPoint2f(contours.get(i).toArray());
	      double peri = Imgproc.arcLength(maxContour2f, false);
	      MatOfPoint2f approx = new MatOfPoint2f();
	      Imgproc.approxPolyDP(maxContour2f, approx, 0.03 * peri, true);

	      if ((int) approx.total() == 4) {
	        double area = Imgproc.contourArea(contours.get(i));

	        if (area > maxArea && area>5000) {
	          maxApprox = approx;
	          maxArea = area;
	        }
	      }
	    }

	    return maxApprox;
		
	}
	
	

	
	
	public static Mat customWarp(Mat source, ArrayList<Double> points) {

	    Point tl = new Point(points.get(0)*source.cols(), points.get(1)*source.rows());
		Point tr = new Point(points.get(2)*source.cols(), points.get(3)*source.rows());
		Point br = new Point(points.get(4)*source.cols(), points.get(5)*source.rows());
		Point bl = new Point(points.get(6)*source.cols(), points.get(7)*source.rows());
	    
	    double widthA = Math.sqrt(Math.pow(br.x - bl.x, 2) + Math.pow(br.y - bl.y, 2));
	    double widthB = Math.sqrt(Math.pow(tr.x - tl.x, 2) + Math.pow(tr.y - tl.y, 2));
	    int maxWidth = (int)Math.max(widthA, widthB);

	    double heightA = Math.sqrt(Math.pow(tr.x - br.x, 2) + Math.pow(tr.y - br.y, 2));
	    double heightB = Math.sqrt(Math.pow(tl.x - bl.x, 2) + Math.pow(tl.y - bl.y, 2));
	    int maxHeight = (int)Math.max(heightA, heightB);

	    MatOfPoint2f dest = new MatOfPoint2f(new Point(0,0), new Point(maxWidth -1, 0), new Point(maxWidth -1, maxHeight -1), new Point(0, maxHeight - 1));

	    MatOfPoint2f temp = new MatOfPoint2f(tl, tr, br,bl);

	    Mat matrix = Imgproc.getPerspectiveTransform(temp, dest);
	    Mat warped = new Mat();
	    Imgproc.warpPerspective(source, warped, matrix, new Size(maxWidth, maxHeight));

	    return  warped;
	  }

	  
	
	public static Mat warp(Mat source, Point[] points) {

	    Point tl = new Point(points[0].x*source.cols(), points[0].y*source.rows());
		Point tr = new Point(points[1].x*source.cols(), points[1].y*source.rows());
		Point br = new Point(points[2].x*source.cols(), points[2].y*source.rows());
		Point bl = new Point(points[3].x*source.cols(), points[3].y*source.rows());
			
	    double widthA = Math.sqrt(Math.pow(br.x - bl.x, 2) + Math.pow(br.y - bl.y, 2));
	    double widthB = Math.sqrt(Math.pow(tr.x - tl.x, 2) + Math.pow(tr.y - tl.y, 2));
	    int maxWidth = (int)Math.max(widthA, widthB);

	    double heightA = Math.sqrt(Math.pow(tr.x - br.x, 2) + Math.pow(tr.y - br.y, 2));
	    double heightB = Math.sqrt(Math.pow(tl.x - bl.x, 2) + Math.pow(tl.y - bl.y, 2));
	    int maxHeight = (int)Math.max(heightA, heightB);

	    MatOfPoint2f dest = new MatOfPoint2f(new Point(0,0), new Point(maxWidth -1, 0), new Point(maxWidth -1, maxHeight -1), new Point(0, maxHeight - 1));

	    MatOfPoint2f temp = new MatOfPoint2f(tl, tr, br,bl);

	    Mat matrix = Imgproc.getPerspectiveTransform(temp, dest);
	    Mat warped = new Mat();
	    Imgproc.warpPerspective(source, warped, matrix, new Size(maxWidth, maxHeight));

	    return  warped;
	  }

	public static Mat warpOrig(Mat image, Point[] bindu) {
	    //Point[] bindu = Cvtest3.sortedPoints(points);

	    Point tl = new Point(bindu[0].x*2, bindu[0].y*2);
	    Point tr = new Point(bindu[1].x*2, bindu[1].y*2);
	    Point br = new Point(bindu[2].x*2, bindu[2].y*2);
	    Point bl = new Point(bindu[3].x*2, bindu[3].y*2);
	    
	    double widthA = Math.sqrt(Math.pow(br.x - bl.x, 2) + Math.pow(br.y - bl.y, 2));
	    double widthB = Math.sqrt(Math.pow(tr.x - tl.x, 2) + Math.pow(tr.y - tl.y, 2));
	    int maxWidth = (int)Math.max(widthA, widthB);

	    double heightA = Math.sqrt(Math.pow(tr.x - br.x, 2) + Math.pow(tr.y - br.y, 2));
	    double heightB = Math.sqrt(Math.pow(tl.x - bl.x, 2) + Math.pow(tl.y - bl.y, 2));
	    int maxHeight = (int)Math.max(heightA, heightB);

	    MatOfPoint2f dest = new MatOfPoint2f(new Point(0,0), new Point(maxWidth -1, 0), new Point(maxWidth -1, maxHeight -1), new Point(0, maxHeight - 1));

	    MatOfPoint2f temp = new MatOfPoint2f(tl, tr, br,bl);

	    Mat matrix = Imgproc.getPerspectiveTransform(temp, dest);
	    Mat warped = new Mat();
	    Imgproc.warpPerspective(image, warped, matrix, new Size(maxWidth, maxHeight));

	    return  warped;
	  }
	
	public static Mat treshold(Mat source) {
	    Mat destination = new Mat();
	    Imgproc.threshold(source, destination, 90, 255, Imgproc.THRESH_TOZERO);
	    return destination;
	  }
	
	public static Mat dilate(Mat source){
	    Mat dilate = new Mat();		
		Mat kernel = Imgproc.getStructuringElement(Imgproc.MORPH_RECT, new  Size((2*2) + 1, (2*2)+1));
	    Imgproc.dilate(source, dilate, kernel);
	    return dilate;
	  }

	  public static Mat erode(Mat source){
	    Mat erode = new Mat();
	    Mat kernel = Imgproc.getStructuringElement(Imgproc.MORPH_RECT, new  Size((2*2) + 1, (2*2)+1));
	    Imgproc.erode(source, erode, kernel);
	    return erode;
	  }
	  
	  public static Mat inversionThreshold(Mat source){
		    Mat tc = new Mat();
		    Imgproc.threshold(source, tc, 200, 255, Imgproc.THRESH_BINARY_INV);
		    return tc;
		  }
	  
	  public static Mat cannyEdgeDetect(Mat source) {
		    Mat destination = new Mat();
		    Imgproc.Canny(source, destination, 20, 50);

		    return destination;
		  }

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