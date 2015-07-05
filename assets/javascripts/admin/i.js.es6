import SiteSetting from 'admin/components/site-setting';
export default {name: 'df-core-admin', after: 'inject-objects', initialize: function() {
	const myTypes = ['df_editor', 'paid_membership_plans', 'paypal_buttons'];
	SiteSetting.reopen({
		partialType: function() {
			var type = this.get('setting.type');
			return -1 < myTypes.indexOf(type) ? type : this._super();
		}.property('setting.type')
		/**
		 * 2015-07-05
		 * Позволяет нам вычленять имя плагина из имени опции и по-разному отображать их.
		 * @see plugins/df-core/assets/stylesheets/admin/_settings.scss
		 */
		,settingName: function() {
			var result = this._super();
			return (
				-1 === result.indexOf('»')
				? result
				: new Handlebars.SafeString(result.replace(/«([^»]+)» (.*)/,
					'<div class="df-setting">' +
						'<div class="plugin-name">$1</div>' +
						'<div class="short-name">$2</div>' +
					'</div>'
				))
			);
		}.property('setting.setting')
	});
}};
