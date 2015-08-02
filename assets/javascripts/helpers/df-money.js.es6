import {sprintf} from '../lib/sprintf';
import registerUnbound from 'discourse/helpers/register-unbound';
registerUnbound('df-money', function(amount, params) {
	return new Handlebars.SafeString(sprintf('%.2f', amount));
});