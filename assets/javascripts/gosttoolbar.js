// strong
jsToolBar.prototype.elements.strong = {
    type: 'button',
    title: 'Strong',
    fn: {
        wiki: function() { this.singleTag('*') }
    }
}

// em
jsToolBar.prototype.elements.em = {
    type: 'button',
    title: 'Italic',
    fn: {
        wiki: function() { this.singleTag("_") }
    }
}

// ins
jsToolBar.prototype.elements.ins = {
    type: 'button',
    title: 'Underline',
    fn: {
        wiki: function() { this.singleTag('+') }
    }
}

// del
jsToolBar.prototype.elements.del = {
    type: 'button',
    title: 'Deleted',
    fn: {
        wiki: function() { this.singleTag('-') }
    }
}

// code
jsToolBar.prototype.elements.code = {
    type: 'button',
    title: 'Code',
    fn: {
        wiki: function() { this.singleTag('@') }
    }
}

// spacer
jsToolBar.prototype.elements.space1 = {type: 'space'}

// spacer
jsToolBar.prototype.elements.space2 = {type: 'space'}

// ul
jsToolBar.prototype.elements.ul = {
    type: 'button',
    title: 'Unordered list',
    fn: {
        wiki: function() {
            this.encloseLineSelection('','',function(str) {
                str = str.replace(/\r/g,'');
                return str.replace(/(\n|^)[#-]?\s*/g,"$1* ");
            });
        }
    }
}

// ol
jsToolBar.prototype.elements.ol = {
    type: 'button',
    title: 'Ordered list',
    fn: {
        wiki: function() {
            this.encloseLineSelection('','',function(str) {
                str = str.replace(/\r/g,'');
                return str.replace(/(\n|^)[*-]?\s*/g,"$1# ");
            });
        }
    }
}

// spacer
jsToolBar.prototype.elements.space3 = {type: 'space'}





// image
jsToolBar.prototype.elements.img = {
    type: 'button',
    title: 'Image',
    fn: {
        wiki: function() { this.encloseSelection("!", "!") }
    }
}

// spacer
jsToolBar.prototype.elements.space5 = {type: 'space'}
// help
/*
jsToolBar.prototype.elements.help = {
    type: 'button',
    title: 'Help',
    fn: {
        wiki: function() { window.open(this.help_link, '', 'resizable=yes, location=no, width=300, height=640, menubar=no, status=no, scrollbars=yes') }
    }
}*/

jsToolBar.prototype.elements.macro = {
    type: 'button',
    title: 'Macro',
    fn: {
        wiki: function() { this.encloseSelection("{{", "}}") }
    }
}

jsToolBar.prototype.elements.cite = {
    type: 'button',
    title: 'Citation',
    fn: {
        wiki: function() {
            wiki = this;
            $.get('../../../../bibliography.json', function(bibs){
                $('#ajax-modal').html(bibs.map(function(bib){
                    return '<div>[<a href="#">' + bib.id + '</a>] ' + bib.title + '</div>';
                }).join(''));

                $("#ajax-modal > div a").on('click', function(){
                    wiki.encloseSelection('{{cite(' + $(this).text() + ')}}');
                    hideModal(this);
                    return false;
                });
                showModal('ajax-modal', 450, 'Библиография');
            })

        }
    }
}

jsToolBar.prototype.elements.section_duplicate = {
    type: 'button',
    title: 'Section Duplicate',
    fn: {
        wiki: function() {
            wiki = this;
            $.get('duplicate/new', function(duplicate_form){
                $('#ajax-modal').html(duplicate_form);
                showModal('ajax-modal', 450, 'Связать с разделом');
            })

        }
    }
}
