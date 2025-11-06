//
//  CastDetailViewController.swift
//  popcorndb
//
//  Created by Nazlı on 10.08.2025.
//
//
//  CastDetailViewController.swift
//  popcorndb
//
import UIKit

final class CastDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var personID: Int!

      private let viewModel = CastDetailViewModel()
      private var infoItems: [(String, String)] = []
      private let spinner = UIActivityIndicatorView(style: .medium)

      private enum ReuseID {
          static let header = "CastHeaderTableViewCell"
          static let info   = "InfoRowTableViewCell"
      }

      override func viewDidLoad() {
          super.viewDidLoad()
          title = "person_cast_member_title".localized
          setupTable()
          fetch()
      }
  }

  private extension CastDetailViewController {
      func setupTable() {
          tableView.delegate = self
          tableView.dataSource = self
          tableView.estimatedRowHeight = 200
          tableView.rowHeight = UITableView.automaticDimension

          tableView.sectionHeaderTopPadding = 0

          tableView.register(UINib(nibName: ReuseID.header, bundle: nil),
                             forCellReuseIdentifier: ReuseID.header)
          tableView.register(UINib(nibName: ReuseID.info, bundle: nil),
                             forCellReuseIdentifier: ReuseID.info)

          spinner.hidesWhenStopped = true
          navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
      }

      func fetch() {
          guard let id = personID else {
              assertionFailure("personID atanmalı")
              return
          }
          spinner.startAnimating()
          viewModel.fetch(personID: id) { [weak self] result in
              DispatchQueue.main.async {
                  guard let self = self else { return }
                  self.spinner.stopAnimating()
                  switch result {
                  case .success(let vd):
                      self.title = vd.name
                      self.buildInfoItems(from: vd)
                      self.tableView.reloadData()
                  case .failure(let e):
                      self.showError(e.description)
                  }
              }
          }
      }

      func buildInfoItems(from vd: CastDetailViewModel.ViewData) {
          infoItems = []
          if let b = vd.birthday, !b.isEmpty     { infoItems.append(("person_birthday".localized, b)) }
          if let p = vd.placeOfBirth, !p.isEmpty { infoItems.append(("person_place_of_birth".localized, p)) }
          if let d = vd.deathday, !d.isEmpty     { infoItems.append(("person_death".localized, d)) }
      }

      func showError(_ message: String) {
          let ac = UIAlertController(title: "general_oops".localized, message: message, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "general_ok".localized, style: .default))
          present(ac, animated: true)
      }
  }

  extension CastDetailViewController: UITableViewDataSource, UITableViewDelegate {

      func numberOfSections(in tableView: UITableView) -> Int { 2 } // 0 header, 1 info

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          section == 0 ? 1 : infoItems.count
      }

      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
          (section == 1 && !infoItems.isEmpty) ? "person_personal_info".localized : nil
      }

      func tableView(_ tableView: UITableView,
                     cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          if indexPath.section == 0 {
              let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.header, for: indexPath) as! CastHeaderTableViewCell
              if let vd = viewModel.viewData {
                  cell.configure(name: vd.name, role: vd.role, biography: vd.biography, imageURL: vd.profileURL)
              } else {
                  cell.configure(name: "", role: "", biography: "", imageURL: nil)
              }
              return cell
          } else {
              let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.info, for: indexPath) as! InfoRowTableViewCell
              let (title, value) = infoItems[indexPath.row]
              cell.configure(title: title, value: value)
              return cell
          }
      }

      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          indexPath.section == 0 ? UITableView.automaticDimension : 56
      }
  }
