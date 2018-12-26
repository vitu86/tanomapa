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
        // When locations are loaded, put them on the map. Until there, the user can use the map without block the UI.
        NotificationCenter.default.addObserver(self, selector: #selector(putLocationsOnMap), name: Notification.Name.locationsLoaded, object: nil)
        // We call this just in case locations are already loaded and no notification is received on start up
        putLocationsOnMap(notification: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Private functions
    @objc private func putLocationsOnMap(notification:Notification?) {
        mapView.removeAnnotations(mapView.annotations)
        for item in DataSingleton.sharedInstance.locations {
            addAnnotation(location: item)
        }
        mapView.setNeedsLayout()
    }
    
    private func addAnnotation(location:StudentInformation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
        
        if let firstName = location.firstName {
            annotation.title = firstName
            if let lastName = location.lastName {
                annotation.title = annotation.title! + " " + lastName
            }
        } else {
            annotation.title = ""
        }
        
        // No need to check here if mediaURL is not nil because the delegate function is already checking
        annotation.subtitle = location.mediaURL
        
        mapView.addAnnotation(annotation)
    }
    
    // MARK: MapViewDelegate functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is MKPointAnnotation) {
            return nil
        }

        let annotationIdentifier = "StudentInformationPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                if let toOpen = toOpen {
                    UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
