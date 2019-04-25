//
//  Launch.swift
//  ARLiu
//
//  Created by Livia Vasconcelos on 23/04/19.
//  Copyright © 2019 LiuVasconcelos. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var goToGame: UIButton!
    @IBAction func goToGame(_ sender: Any) {
        let instructions = "Seu objetivo é salvar os peixinhos do aquário. Para isto, você deve alimentar os peixinhos dourados com uma frutinha e tirar os tubarões de perto com o machado. Cada acerto no alvo, você ganhará um ponto, e para cada erro, perderá um ponto. Nada de alimentar os tubarões e matar os peixinhos hein?!"
        let alertController = UIAlertController(title: "Regras do jogo", message: instructions, preferredStyle: .alert)
        let settingsAction  = UIAlertAction(title: "Vamos lá?", style: .default) { (_) -> Void in
           self.startGame()
        }
        let cancelAction = UIAlertAction(title: "Não quer jogar agora? Tudo bem!", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func startGame() {
        let viewController  = MainViewController.fromNib().or(MainViewController())
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
