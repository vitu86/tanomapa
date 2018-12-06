//
//  MapViewController.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 06/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(putLocationsOnMap), name: Notification.Name.locationsLoaded, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Private functions
    @objc private func putLocationsOnMap(notification:Notification) {
        mapView.removeAnnotations(mapView.annotations)
        for item in NetworkHelper.sharedInstance.studentsInformation {
            addAnnotation(location: item)
        }
    }
    
    private func addAnnotation(location:StudentInformation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
        mapView.addAnnotation(annotation)
    }
    
    // MARK: MapViewDelegate functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "StudentInformationPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage:UIImage = UIImage.init(named: "IconPin")!
        annotationView!.image = pinImage
        
        return annotationView
    }
}
