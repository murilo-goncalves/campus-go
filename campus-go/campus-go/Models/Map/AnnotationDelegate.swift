//
//  AnnotationDelegate.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 17/11/21.
//

import Foundation

protocol AnnotationDelegate: AnyObject {
    func updateAnnotations()
    
    func updateAnnotation(annotation: CustomAnnotation)
}
