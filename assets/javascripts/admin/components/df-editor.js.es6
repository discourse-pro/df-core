import loadScript from 'discourse/lib/load-script';
export default Ember.Component.extend({
	classNames: ['df-editor-component']
	, _suffix: undefined
	,_init: function() {
		this._suffix = '-' + Math.floor(10000 * Math.random()).toString();
		this.set('buttonBarId', 'wmd-button-bar' + this._suffix);
		this.set('textareaId', 'wmd-input' + this._suffix);
		this.set('previewId', 'wmd-preview' + this._suffix);
	}.on('init')
	,_initializeWmd: function() {
		var $textarea = $('textarea', this.$());
		const self = this;
		loadScript('defer/html-sanitizer-bundle').then(function() {
			$textarea.data('init', true);
			self._editor = self.createEditor();
			self._editor.run();
			var buttonsToHide = ['wmd-quote-button', 'wmd-quote-post', 'wmd-image-button'];
			$('.wmd-button', self.$()).each(function() {
				var $this = $(this);
				var cssClass = this.id.replace(self._suffix, '');
				$this.addClass(this.id.replace(self._suffix, ''));
				if (-1 < buttonsToHide.indexOf(cssClass)) {
					$this.hide();
				}
			});
			Ember.run.scheduleOnce('afterRender', self, self._refreshPreview);
		});
	}.on('didInsertElement')
	,createEditor: function() {
		return new Markdown.Editor(
			Discourse.Markdown.markdownConverter({sanitize: true})
			, this._suffix
			, {strings: {
				bold: I18n.t("composer.bold_title") + " <strong> Ctrl+B",
				boldexample: I18n.t("composer.bold_text"),
				italic: I18n.t("composer.italic_title") + " <em> Ctrl+I",
				italicexample: I18n.t("composer.italic_text"),
				link: I18n.t("composer.link_title") + " <a> Ctrl+L",
				linkdescription: I18n.t("composer.link_description"),
				linkdialog: "<p><b>" + I18n.t("composer.link_dialog_title") + "</b></p><p>http://example.com/ \"" +
				I18n.t("composer.link_optional_text") + "\"</p>",
				quote: I18n.t("composer.quote_title") + " <blockquote> Ctrl+Q",
				quoteexample: I18n.t("composer.quote_text"),
				code: I18n.t("composer.code_title") + " <pre><code> Ctrl+K",
				codeexample: I18n.t("composer.code_text"),
				image: I18n.t("composer.upload_title") + " - Ctrl+G",
				imagedescription: I18n.t("composer.upload_description"),
				olist: I18n.t("composer.olist_title") + " <ol> Ctrl+O",
				ulist: I18n.t("composer.ulist_title") + " <ul> Ctrl+U",
				litem: I18n.t("composer.list_item"),
				heading: I18n.t("composer.heading_title") + " <h1>/<h2> Ctrl+H",
				headingexample: I18n.t("composer.heading_text"),
				hr: I18n.t("composer.hr_title") + " <hr> Ctrl+R",
				undo: I18n.t("composer.undo_title") + " - Ctrl+Z",
				redo: I18n.t("composer.redo_title") + " - Ctrl+Y",
				redomac: I18n.t("composer.redo_title") + " - Ctrl+Shift+Z",
				help: I18n.t("composer.help")
			}}
		);
	}
	,observeValue: function() {
		Ember.run.scheduleOnce('afterRender', this, this._refreshPreview);
	}.observes('value'),
	_refreshPreview() {
		this._editor.refreshPreview();
	}
});
