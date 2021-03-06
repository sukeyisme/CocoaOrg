//
//  CocoaOrgTests.swift
//  CocoaOrgTests
//
//  Created by Xiaoxing Hu on 14/08/16.
//  Copyright © 2016 Xiaoxing Hu. All rights reserved.
//

import XCTest
@testable import CocoaOrg


class LexerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        defineTokens()
    }
    
    func testTokenBlank() {
        evalBlank("", rawIsNil: true)
        evalBlank(" ")
        evalBlank("\t")
        evalBlank("  \t  ")
    }
    
    func testTokenSetting() {
        evalSetting("#+options: toc:nil", key: "options", value: "toc:nil")
        evalSetting("#+options:    toc:nil", key: "options", value: "toc:nil")
        evalSetting("#+TITLE: hello world", key: "TITLE", value: "hello world")
        evalSetting("#+TITLE: ", key: "TITLE", value: nil)
        evalSetting("#+TITLE:", key: "TITLE", value: nil)
    }
    
    func testTokenHeading() {
        evalHeadline("* Level One", level: 1, text: "Level One")
        evalHeadline("** Level Two", level: 2, text: "Level Two")
        evalHeadline("* TODO Level One with todo", level: 1, text: "TODO Level One with todo")
        evalHeadline("* ", level: 1, text: nil)
        evalLine("*", text: "*")
        evalListItem(" * ", indent: 1, text: nil, ordered: false)
    }
    
    func testTokenBlockBegin() {
        evalBlockBegin("#+begin_src java", type: "src", params: ["java"])
        evalBlockBegin("  #+begin_src", type: "src", params: nil)
        evalBlockBegin("  #+begin_src yaml exports: results :results value html",
                       type: "src",
                       params: ["yaml", "exports:", "results", ":results", "value", "html"])
    }
    
    func testTokenBlockEnd() {
        evalBlockEnd("#+END_SRC", type: "SRC")
        evalBlockEnd("  #+end_src", type: "src")
    }
    
    func testTokenComment() {
        evalComment("# a line of comment", text: "a line of comment")
        evalComment("#    a line of comment", text: "a line of comment")
        evalLine("#not comment", text: "#not comment")
    }
    
    func testTokenHorizontalRule() {
        evalHorizontalRule("-----")
        evalHorizontalRule("----------")
        evalHorizontalRule("  -----")
    }
    
    func testTokenListItem() {
        evalListItem("- list item", indent: 0, text: "list item", ordered: false)
        evalListItem(" + list item", indent: 1, text: "list item", ordered: false)
        evalListItem("  * list item", indent: 2, text: "list item", ordered: false)
        evalListItem("1. ordered list item", indent: 0, text: "ordered list item", ordered: true)
        evalListItem("  200) ordered list item", indent: 2, text: "ordered list item", ordered: true)
        // checkboxes
        evalListItem("- [ ] checkbox", indent: 0, text: "checkbox", ordered: false, checked: false)
        evalListItem("- [-] checkbox", indent: 0, text: "checkbox", ordered: false, checked: false)
        evalListItem("- [X] checkbox", indent: 0, text: "checkbox", ordered: false, checked: true)
        // illegal checkboxes
        evalListItem("- [] checkbox", indent: 0, text: "[] checkbox", ordered: false, checked: nil)
        evalListItem("- [X]checkbox", indent: 0, text: "[X]checkbox", ordered: false, checked: nil)
        evalListItem("- [Y] checkbox", indent: 0, text: "[Y] checkbox", ordered: false, checked: nil)
        evalLine("-[X] checkbox", text: "-[X] checkbox")
    }
    
    func testDrawer() {
        evalDrawerBegin(":PROPERTY:", name: "PROPERTY")
        evalDrawerBegin("  :properties:", name: "properties")
        evalDrawerBegin("  :properties:  ", name: "properties")
        evalDrawerEnd(":END:")
        evalDrawerEnd("  :end:")
        evalDrawerEnd("  :end:   ")
    }
    
    func testFootnote() {
        evalFootnote("[fn:1] the footnote", label: "1", content: "the footnote")
        evalFootnote("[fn:1]  \t the footnote", label: "1", content: "the footnote")
        evalFootnote("[fn:999] the footnote", label: "999", content: "the footnote")
        evalFootnote("[fn:23]", label: "23", content: nil)
        evalFootnote("[fn:23]  ", label: "23", content: nil)
        evalLine(" [fn:1] the footnote", text: "[fn:1] the footnote")
        evalLine("a[fn:1] the footnote", text: "a[fn:1] the footnote")
        evalLine("[fn:1]the footnote", text: "[fn:1]the footnote")
    }
}
