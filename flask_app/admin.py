from flask_admin import Admin
from flask_admin.contrib.sqla import ModelView
from models import User

from app import app,db

app.config['FLASK_ADMIN_SWATCH'] = 'cerulean'

admin = Admin(app)
admin.add_view(ModelView(User, db.session))
