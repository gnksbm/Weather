//
//  WeatherLocationCVCell.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import UIKit
import MapKit

import Neat
import SnapKit

final class WeatherLocationCVCell: BaseCollectionViewCell {
    private let mapView = MKMapView().nt.configure {
        $0.isScrollEnabled(false)
    }
    
    func configureCell(
        item:
        WeatherLocationInfo
    ) {
        let coordinate = CLLocationCoordinate2D(
            latitude: item.latitude,
            longitude: item.longitude
        )
        mapView.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
            )
        )
        mapView.annotations.forEach{
            mapView.removeAnnotation($0)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    override func configureLayout() {
        [mapView].forEach { contentView.addSubview($0) }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
    }
}
