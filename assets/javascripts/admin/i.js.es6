import SiteSetting from 'admin/components/site-setting';
export default {name: 'df-core-admin', initialize() {
	/** @type {String[]} */
	const myTypes = [
		'df_editor', 'df_password', 'df_textarea', 'paid_membership_plans', 'paypal_buttons'
	];
	SiteSetting.reopen({
		/**
		 * 2015-07-06
		 * Обратите внимание, что в родительском классе
		 * присутствует свой обработчик «didInsertElement»,
		 * однако он никоим образом не конфликтует с нашим,
		 * потому что функция-обработчик называется по-другому.
		 *
		 * Наша задача: назначить индивидуальный класс CSS
		 * родительскому контейнеру компонента: .row.setting
		 */
		_dfDidInsertElement: function() {
			const settingName = this.get('setting.setting');
			// Проворачиваем нашу операцию только для наших настроек,
			// не затрагивая настройки ядра.
			if (-1 < settingName.indexOf('«')) {
				this.$().closest('.row.setting').addClass(this.get('setting.setting'));
			}
		}.on('didInsertElement')
		,componentType: function() {
			var type = this.get('setting.type');
			return -1 < myTypes.indexOf(type) ? type : this._super();
		}.property('setting.type')
		/**
		 * 2015-08-27
		 * https://meta.discourse.org/t/32572
		 */
		,typeClass: function() {
			return this.get('componentType').replace(/_/g, '-');
		}.property('componentType')
		/**
		 * 2015-07-05
		 * Позволяет нам вычленять имя плагина из имени опции и по-разному отображать их.
		 * @see plugins/df-core/assets/stylesheets/admin/_settings.scss
		 */
		,settingName: function() {
			const result = this._super();
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
